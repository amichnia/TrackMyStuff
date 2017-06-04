//
// Copyright (c) 2017 GirAppe Studio. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AssignBeaconViewController: BaseViewController {
    @IBOutlet weak var proximityTextField: UITextField!
    @IBOutlet weak var motionTextField: UITextField!
    @IBOutlet weak var minorTextField: UITextField!
    @IBOutlet weak var majorTextField: UITextField!
    @IBOutlet weak var assignmentButton: UIButton!
    @IBOutlet var coloredLabels: [UILabel]!
    @IBOutlet var lineViews: [UIView]!

    lazy var cancelButton: UIBarButtonItem! = { self.closeBarButtonItem() }()

    var viewModel: AssignBeaconViewModelType!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUIBindings()
        setupDataBindings()
        localize()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        viewModel.complete()
    }

    private func setupUIBindings() {
        addRightItem(item: cancelButton)

        let backgroundColor = viewModel.theme.asObservable().map { $0.background }
        let foregroundColor = viewModel.theme.asObservable().map { $0.foreground }
        let captionColor = viewModel.theme.asObservable().map { $0.caption }

        backgroundColor.bind(to: view.rx.backgroundColor) >>> bag
        lineViews.forEach { line in
            foregroundColor.bind(to: line.rx.backgroundColor) >>> self.bag
        }
        coloredLabels.forEach { label in
            captionColor.bind(to: label.rx.textColor) >>> self.bag
        }

        foregroundColor.bind(to: assignmentButton.rx.tintColor) >>> bag
        foregroundColor.bind(to: assignmentButton.rx.titleColor()) >>> bag
        foregroundColor.bind(to: cancelButton.rx.tintColor) >>> bag
        foregroundColor.bind(to: proximityTextField.rx.textColor) >>> bag
        foregroundColor.bind(to: motionTextField.rx.textColor) >>> bag
        foregroundColor.bind(to: minorTextField.rx.textColor) >>> bag
        foregroundColor.bind(to: majorTextField.rx.textColor) >>> bag
    }

    private func setupDataBindings() {
        proximityTextField.rx.text <-> viewModel.beaconViewModel.proximityUUID >>> bag
        motionTextField.rx.text <-> viewModel.beaconViewModel.motionUUID >>> bag
        majorTextField.rx.text <-> viewModel.beaconViewModel.major >>> bag
        minorTextField.rx.text <-> viewModel.beaconViewModel.minor >>> bag

        viewModel.beaconViewModel.isAssigned.asObservable().map({ assigned -> String in
            return assigned ? R.string.localizable.assignBeaconButtonUpadte() : R.string.localizable.assignBeaconButtonAssign()
        }).bind(to: assignmentButton.rx.title()) >>> bag
        viewModel.canAssign.asObservable().bind(to: assignmentButton.rx.isEnabled) >>> bag
        viewModel.beaconViewModel.isAssigned.asObservable().bind(to: cancelButton.rx.isEnabled) >>> bag

        cancelButton.rx.tap.asObservable().subscribe(onNext: {
            self.unassignAction(self)
        }) >>> bag
    }

    private func localize() {
        navigationItem.title = R.string.localizable.assignBeaconNaviationTitle()
        //todo labels
    }

    @IBAction func assignAction(_ sender: Any) {
        viewModel.assign(sender: self)
    }

    @IBAction func unassignAction(_ sender: Any) {
        viewModel.unassign(sender: self)
    }

    @IBAction func dismissKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
}
