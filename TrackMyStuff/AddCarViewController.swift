//
// Copyright (c) 2017 GirAppe Studio. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AddCarViewController: BaseViewController {
    @IBOutlet weak var collectionView: PagedCollectionView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var assignButton: UIButton!
    @IBOutlet weak var highlightView: UIView!
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
        collectionView.rx.pageProgress --> viewModel.page >>> bag
        viewModel.backgroundColor.asObservable().bind(to: view.rx.backgroundColor) >>> bag
        if let bar = navigationController?.navigationBar {
            viewModel.backgroundColor.asObservable().bind(to: bar.rx.barTintColor) >>> bag
        }
        viewModel.color.asObservable().bind(to: assignButton.rx.tintColor) >>> bag
        viewModel.color.asObservable().bind(to: cancelButton.rx.tintColor) >>> bag
        viewModel.color.asObservable().observeOnMain().subscribe(onNext: { color in
            self.highlightView.layer.borderColor = color.cgColor
            self.nameTextField.textColor = color
            self.assignButton.setTitleColor(color, for: .normal)
            self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: color]
        }) >>> bag
        viewModel.iconsCount.asObservable().observeOnMain().asVoid().subscribe(onNext: { self.collectionView.reloadData() }) >>> bag
        cancelButton.rx.tap.asObservable().observeOnMain().subscribe(onNext: { self.viewModel.cancel(addingFrom: self) }) >>> bag
    }

    private func setupUI() {
        highlightView.layer.cornerRadius = highlightView.bounds.width / 2
        highlightView.layer.borderWidth = 1
        addLeftItem(item: cancelButton)
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
