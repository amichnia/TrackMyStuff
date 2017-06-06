//
// Copyright (c) 2017 GirAppe Studio. All rights reserved.
//

import Foundation
import Swinject
import SwinjectStoryboard

class ItemsAssembly: Assembly {
    func assemble(container: Container) {
        assembleStorage(in: container)

        container.register(ItemsWorkflowType.self) { _ in
            return ItemsWorkflow()
        }

        container.register(ItemsViewModelType.self) { resolver in
            let main = resolver.resolve(MainWorkflowType.self)!
            let storage = resolver.resolve(ItemsStorageType.self)!
            return ItemsViewModel(workflow: main, storage: storage)
        }

        container.storyboardInitCompleted(ItemsViewController.self) { (resolver: Resolver, controller: ItemsViewController) in
            controller.viewModel = resolver.resolve(ItemsViewModelType.self)
        }
    }

    func assembleStorage(in container: Container) {
        container.register(ItemsStorageType.self) { _ in
            return ItemsStorage()
        }.inObjectScope(.container)
    }
}
