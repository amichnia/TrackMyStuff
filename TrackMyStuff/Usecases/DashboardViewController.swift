//
// Copyright (c) 2017 GirAppe Studio. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Swinject

class DashboardViewController: UIViewController {
    @IBOutlet weak var pageContainer: PagesControllerContainerView!
    @IBOutlet weak var itemsSelectionContainer: UIView!

    let bag = DisposeBag()
    var resolver: Resolver!
    var viewModel: DashboardViewModelType!

    lazy var tabsSelection: TabSelectionView = {
        return TabSelectionView.load(from: R.nib.tabSelectionView()).insert(into: self.itemsSelectionContainer)
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        localize()
        setupObservers()
    }

    // MARK: - Configuration
    private func localize() {

    }

    private func setupObservers() {
        viewModel.items.drive(onNext: { [weak self] pages in
            self?.setup(with: pages)
        }) >>> bag
    }

    private func setup(with pages: [ItemDetailsViewModelType]) {
        let controllers = pages.map { model -> ItemDetailsViewController in
            return resolver.resolve(ItemDetailsViewController.self, argument: model)!
        }
        let titles = pages.map { $0.title }

        pageContainer.setup(with: controllers)
        self.addChildViewController(pageContainer.pageController)
        pageContainer.pageController.didMove(toParentViewController: self)

        tabsSelection.setItems(titles: titles, selected: 0)

        tabsSelection.rx.itemSelected.asDriver().drive(onNext: { [weak self] item in
            self?.pageContainer.move(to: item)
        }) >>> bag
    }
}

protocol UIViewType {}
extension UIView: UIViewType {}

fileprivate extension UIViewType where Self: UIView {
    func insert(into container: UIView) -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(self)
        self.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        return self
    }
}
