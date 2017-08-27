//
// Copyright (c) 2017 GirAppe Studio. All rights reserved.
//

import UIKit
import SnapKit

struct DashboardDetailsPage {
    var title: String
    var controller: UIViewController
//    var accent: UIColor
}

class DashboardViewController: UIViewController {
    @IBOutlet weak var pageContainer: PagesControllerContainerView!
    @IBOutlet weak var itemsSelectionContainer: UIView!

    var viewModel: DashboardViewModelType!

    lazy var tabsSelection: TabSelectionView = {
        return TabSelectionView.load(from: R.nib.tabSelectionView()).insert(into: self.itemsSelectionContainer)
    }()

    private func setup(with pages: [DashboardDetailsPage]) {
        let controllers = pages.map { $0.controller }
        pageContainer.setup(with: controllers)
        self.addChildViewController(pageContainer.pageController)
        pageContainer.pageController.didMove(toParentViewController: self)

//        tabsSelection.
//
//        let pages = self.pages.map { $0.page }
//        bottomMenu.clear()
//
//        pages.enumerated().forEach { (index: Int, page: SecondLoginPage) in
//            let button = self.button(for: page)
//            bottomMenu.add(button)
//
//            button.rx.tap.asDriver().drive(onNext: { [weak self] in
//                self?.container.move(to: index)
//            }) >>> bag
//        }
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
