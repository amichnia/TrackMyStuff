//
// Copyright (c) 2017 GirAppe Studio. All rights reserved.
//

import Foundation
import Swinject
import SwinjectStoryboard

class MainAssembly: Assembly {
    func assemble(container: Container) {
        SwinjectStoryboard.defaultContainer = container

        assembleMain(in: container)
        assembleBaseNavigation(in: container)
    }

    func assembleMain(in container: Container) {
         container.register(MainWorkflowType.self) { resolver in
            let main = MainWorkflow()
            main.addCarWorkflow = resolver.resolve(AddCarWorkflowType.self)

            return main
        }.inObjectScope(.container)
    }

    func assembleBaseNavigation(in container: Container) {
        container.register(TabBarViewModelType.self) { resolver in
            let main = resolver.resolve(MainWorkflowType.self)!
            return TabBarViewModel(workflow: main)
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
