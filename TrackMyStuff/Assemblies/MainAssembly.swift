//
// Copyright (c) 2017 GirAppe Studio. All rights reserved.
//

import Foundation
import Swinject
import SwinjectStoryboard
import BTracker

class MainAssembly: Assembly {
    func assemble(container: Container) {
        SwinjectStoryboard.defaultContainer = container

        assembleMain(in: container)
        assembleBaseNavigation(in: container)
    }

    func assembleMain(in container: Container) {
        container.register(MainWorkflowType.self) { resolver in
            let main = MainWorkflow()
            main.itemsWorkflow = resolver.resolve(ItemsWorkflowType.self)
            main.addItemWorkflow = resolver.resolve(AddItemWorkflowType.self)
            return main
        }.inObjectScope(.container)
    }

    func assembleBaseNavigation(in container: Container) {
        container.register(TrackingManager.self) { _ in
            return TrackingManager()
        }

        container.register(TabBarViewModelType.self) { resolver in
            let main = resolver.resolve(MainWorkflowType.self)!
            let storage = resolver.resolve(ItemsStorageType.self)!
            let tracker = resolver.resolve(TrackingManager.self)!
            return TabBarViewModel(workflow: main, storage: storage, tracker: tracker)
        }

        container.storyboardInitCompleted(BaseNavigationController.self) { (resolver: Resolver, controller: BaseNavigationController) in
            // TODO: DI
        }

        container.storyboardInitCompleted(BaseViewController.self) { (resolver: Resolver, controller: BaseViewController) in
            // TODO: DI
        }

        container.storyboardInitCompleted(BaseTabBarController.self) { (resolver: Resolver, controller: BaseTabBarController) in
            controller.viewModel = resolver.resolve(TabBarViewModelType.self)
        }
    }
}
