//
// Copyright (c) 2017 GirAppe Studio. All rights reserved.
//

import Foundation
import Swinject
import SwinjectStoryboard
import BTracker

class MapAssembly: Assembly {
    func assemble(container: Container) {
        container.register(MapViewModelType.self) { resolver in
            let main = resolver.resolve(MainWorkflowType.self)!
            let storage = resolver.resolve(ItemsStorageType.self)!
            return MapViewModel(workflow: main, storage: storage)
        }

        container.storyboardInitCompleted(MapViewController.self) { (resolver: Resolver, controller: MapViewController) in
            controller.viewModel = resolver.resolve(MapViewModelType.self)
        }
    }
}
