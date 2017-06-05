//
// Copyright (c) 2017 GirAppe Studio. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AddCarViewController: BaseViewController {
    @IBOutlet weak var collectionView: PagedCollectionView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var assignLabel: UILabel!
    @IBOutlet weak var assignButton: UIButton!
    @IBOutlet weak var highlightView: UIView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet var coloredLabels: [UILabel]!
    @IBOutlet var lineViews: [UIView]!
    lazy var cancelButton: UIBarButtonItem! = { self.closeBarButtonItem() }()

    var viewModel: AddCarViewModelType!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBindings()
        setupUI()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        collectionView.setupLayout()
    }

    private func setupBindings() {
        let backgroundColor = viewModel.theme.asObservable().map { $0.background }
        let foregroundColor = viewModel.theme.asObservable().map { $0.foreground }
        let captionColor = viewModel.theme.asObservable().map { $0.caption }

        collectionView.rx.pageProgress --> viewModel.page >>> bag
        backgroundColor.bind(to: view.rx.backgroundColor) >>> bag

        lineViews.forEach { line in
            foregroundColor.bind(to: line.rx.backgroundColor) >>> self.bag
        }
        coloredLabels.forEach { label in
            foregroundColor.bind(to: label.rx.textColor) >>> self.bag
        }
        if let bar = navigationController?.navigationBar {
            backgroundColor.bind(to: bar.rx.barTintColor) >>> bag
            foregroundColor.bind(to: bar.rx.tintColor) >>> bag
            foregroundColor.bind(to: bar.rx.titleColor) >>> bag
        }
        foregroundColor.bind(to: assignButton.rx.tintColor) >>> bag
        foregroundColor.bind(to: assignButton.rx.titleColor()) >>> bag
        foregroundColor.bind(to: cancelButton.rx.tintColor) >>> bag
        foregroundColor.bind(to: addButton.rx.tintColor) >>> bag

        viewModel.canAdd.asObservable().bind(to: addButton.rx.isEnabled) >>> bag

        foregroundColor.observeOnMain().subscribe(onNext: { color in
            self.highlightView.layer.borderColor = color.cgColor
        }) >>> bag

        captionColor.bind(to: nameTextField.rx.textColor) >>> bag

        viewModel.iconsCount.asObservable().observeOnMain().asVoid().subscribe(onNext: { self.collectionView.reloadData() }) >>> bag
        cancelButton.rx.tap.asObservable().observeOnMain().subscribe(onNext: { self.viewModel.cancel(sender: self) }) >>> bag

        viewModel.beaconViewModel.assignmentButtonText.asObservable().bind(to: assignButton.rx.title()) >>> bag
    }

    private func setupUI() {
        highlightView.layer.cornerRadius = highlightView.bounds.width / 2
        highlightView.layer.borderWidth = 1
        addLeftItem(item: cancelButton)
    }

    private func localize() {
        navigationItem.title = R.string.localizable.addCarNaviationTitle()
        nameLabel.text = R.string.localizable.addCarAddLabel()
        nameTextField.placeholder = R.string.localizable.addCarAddPlaceholder()
        nameTextField.text = R.string.localizable.addCarAddDefault()
        assignLabel.text = R.string.localizable.addCarBeaconLabel()
    }

    @IBAction func add(_ sender: Any) {
        viewModel.addCar(sender: self)
    }

    @IBAction func assignBeacon(_ sender: Any) {
        viewModel.assignBeacon(sender: self)
    }

    @IBAction func dismissKeyboard(_ sender: Any) {
        nameTextField.resignFirstResponder()
    }
}

extension AddCarViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.iconsCount.value
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.deque(R.reuseIdentifier.addCarCollectionViewCell, for: indexPath)
        viewModel.setup(cell: cell, at: indexPath)
        return cell
    }
}
