//
// Copyright (c) 2017 GirAppe Studio. All rights reserved.
//

import Foundation
import Swinject
import SwinjectStoryboard

class AddItemAssembly: Assembly {
    func assemble(container: Container) {
        container.register(AddItemWorkflowType.self) { resolver in
            return AddItemWorkflow()
        }

        assembleAddCar(in: container)
        assembleAssignBeacon(in: container)
    }

    func assembleAddCar(in container: Container) {
        container.register(AddItemViewModelType.self) { resolver in
            let main = resolver.resolve(MainWorkflowType.self)!
            let beaconViewModel = resolver.resolve(BeaconViewModelType.self)!
            let storage = resolver.resolve(ItemsStorageType.self)!
            return AddItemViewModel<Item>(workflow: main, beacon: beaconViewModel, icons: Item.icons, storage: storage)
        }

        container.register(AddItemViewModelType.self, name: TrackedItemType.other.rawValue) { resolver in
            let main = resolver.resolve(MainWorkflowType.self)!
            let beaconViewModel = resolver.resolve(BeaconViewModelType.self)!
            let storage = resolver.resolve(ItemsStorageType.self)!
            return AddItemViewModel<Item>(workflow: main, beacon: beaconViewModel, icons: Item.icons, storage: storage)
        }

        container.register(AddItemViewModelType.self, name: TrackedItemType.bike.rawValue) { resolver in
            let main = resolver.resolve(MainWorkflowType.self)!
            let beaconViewModel = resolver.resolve(BeaconViewModelType.self)!
            let storage = resolver.resolve(ItemsStorageType.self)!
            return AddItemViewModel<Bike>(workflow: main, beacon: beaconViewModel, icons: Bike.icons, storage: storage)
        }

        container.register(AddItemViewModelType.self, name: TrackedItemType.car.rawValue) { resolver in
            let main = resolver.resolve(MainWorkflowType.self)!
            let beaconViewModel = resolver.resolve(BeaconViewModelType.self)!
            let storage = resolver.resolve(ItemsStorageType.self)!
            return AddItemViewModel<Car>(workflow: main, beacon: beaconViewModel, icons: Car.icons, storage: storage)
        }

        container.storyboardInitCompleted(AddItemViewController.self) { (resolver: Resolver, controller: AddItemViewController) in
            // empty ?
        }

        container.storyboardInitCompleted(AddCarNavigationController.self) { (resolver: Resolver, controller: AddCarNavigationController) in
            guard let addItemController = controller.topViewController as? AddItemViewController else  { return }

            addItemController.viewModel = resolver.resolve(AddItemViewModelType.self, name: TrackedItemType.car.rawValue)
        }

        container.storyboardInitCompleted(AddBikeNavigationController.self) { (resolver: Resolver, controller: AddBikeNavigationController) in
            guard let addItemController = controller.topViewController as? AddItemViewController else  { return }

            addItemController.viewModel = resolver.resolve(AddItemViewModelType.self, name: TrackedItemType.bike.rawValue)
        }

        container.storyboardInitCompleted(AddItemNavigationController.self) { (resolver: Resolver, controller: AddItemNavigationController) in
            guard let addItemController = controller.topViewController as? AddItemViewController else  { return }

            addItemController.viewModel = resolver.resolve(AddItemViewModelType.self, name: TrackedItemType.other.rawValue)
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
