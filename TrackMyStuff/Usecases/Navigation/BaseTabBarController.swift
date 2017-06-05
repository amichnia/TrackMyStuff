//
// Copyright (c) 2017 GirAppe Studio. All rights reserved.
//

import UIKit

protocol TabBarViewModelType {
    func addNewCar(start view: SourceViewType)
}

class TabBarViewModel: TabBarViewModelType {
    fileprivate var workflow: MainWorkflowType

    init(workflow: MainWorkflowType) {
        self.workflow = workflow
    }

    func addNewCar(start view: SourceViewType) {
        workflow.addCarWorkflow.start(from: view)
    }
}

class BaseTabBarController: UITabBarController {
    var viewModel: TabBarViewModelType!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // TODO: test
        viewModel.addNewCar(start: self)
    }
}
