//
// Copyright (c) 2017 GirAppe Studio. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BaseTabBarController: UITabBarController {
    var viewModel: TabBarViewModelType!

    let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.start(sender: self)
        setupBindings()
    }

    func setupBindings() {
        viewModel.currentTab.asObservable().subscribe(onNext: { tab in
            self.selectedIndex = tab.rawValue
        }) >>> bag
    }
}
