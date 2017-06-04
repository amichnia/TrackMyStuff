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

        assembleAddCar(in: container)
        assembleAssignBeacon(in: container)
    }

    func assembleAddCar(in container: Container) {
        container.register(AddCarViewModelType.self) { resolver in
            let main = resolver.resolve(MainWorkflowType.self)!
            let beaconViewModel = resolver.resolve(BeaconViewModelType.self)!
            return AddCarViewModel(workflow: main, beacon: beaconViewModel)
        }

        container.storyboardInitCompleted(AddCarViewController.self) { (resolver: Resolver, controller: AddCarViewController) in
            controller.viewModel = resolver.resolve(AddCarViewModelType.self)
        }
    }

    func assembleAssignBeacon(in container: Container) {
        container.register(BeaconViewModelType.self) { resolver in
            return BeaconViewModel(beacon: nil)
        }

        container.register(AssignBeaconViewModelType.self) { resolver in
            let main = resolver.resolve(MainWorkflowType.self)!
            let beaconViewModel = resolver.resolve(BeaconViewModelType.self)!
            return AssignBeaconViewModel(workflow: main, beacon: beaconViewModel)
        }

        container.storyboardInitCompleted(AssignBeaconViewController.self) { (resolver: Resolver, controller: AssignBeaconViewController) in
            controller.viewModel = resolver.resolve(AssignBeaconViewModelType.self)
        }
    }
}
