//
// Copyright (c) 2017 GirAppe Studio. All rights reserved.
//

import Foundation
import Swinject
import SwinjectStoryboard

class AddCarAssembly: Assembly {
    func assemble(container: Container) {
        container.register(AddCarWorkflowType.self) { resolver in
            return AddCarWorkflow()
        }

        container.register(AddCarViewModelType.self) { resolver in
            let main = resolver.resolve(MainWorkflowType.self)!
            return AddCarViewModel(workflow: main)
        }

        container.storyboardInitCompleted(AddCarViewController.self) { (resolver: Resolver, controller: AddCarViewController) in
            controller.viewModel = resolver.resolve(AddCarViewModelType.self)
        }
    }
}
