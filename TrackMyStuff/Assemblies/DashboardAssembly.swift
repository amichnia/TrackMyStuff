//
// Copyright (c) 2017 GirAppe Studio. All rights reserved.
//

import Foundation
import Swinject
import SwinjectStoryboard
import BTracker

class DashboardAssembly: Assembly {
    func assemble(container: Container) {
        assembleDashboard(in: container)
        assembleItemDetails(in: container)
    }

    func assembleDashboard(in container: Container) {
        container.register(DashboardViewModelType.self) { resolver in
            let workflow = resolver.resolve(MainWorkflowType.self)!
            return DashboardViewModel(workflow: workflow)
        }

        container.storyboardInitCompleted(DashboardViewController.self) { (resolver, controller: DashboardViewController) in
            controller.resolver = resolver
            controller.viewModel = resolver.resolve(DashboardViewModelType.self)
        }
    }

    func assembleItemDetails(in container: Container) {
        container.register(ItemDetailsViewController.self) { (resolver: Resolver, model: ItemDetailsViewModelType) in
            let view = R.storyboard.dashboard.itemDetailsViewController()!
            view.viewModel = model
            return view
        }
    }
}
