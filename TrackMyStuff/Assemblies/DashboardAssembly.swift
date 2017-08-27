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
        container.register(DashboardViewModelType.self) { _ in
            return DashboardViewModel()
        }

        container.storyboardInitCompleted(DashboardViewController.self) { (resolver, controller: DashboardViewController) in
            controller.viewModel = resolver.resolve(DashboardViewModelType.self)
        }
    }

    func assembleItemDetails(in container: Container) {
        container.register(ItemDetailsViewModelType.self) { _ in
            return ItemDetailsViewModel()
        }

        container.storyboardInitCompleted(ItemDetailsViewController.self) { (resolver, controller: ItemDetailsViewController) in
            controller.viewModel = resolver.resolve(ItemDetailsViewModelType.self)
        }
    }
}
