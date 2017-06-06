//
// Copyright (c) 2017 GirAppe Studio. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {
    var viewModel: TabBarViewModelType!

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.start(sender: self)
    }
}
