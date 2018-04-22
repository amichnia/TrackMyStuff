//
// Copyright (c) 2017 GirAppe Studio. All rights reserved.
//

import UIKit
import RxSwift
import Swinject
import SwinjectStoryboard
import BTracker

protocol AddItemWorkflowType: class, AnyWorkflowType {
    func start(from view: SourceViewType, with type: TrackedItemType)
    func assignBeacon(with beacon: Beacon?, theme: BasicViewTheme, sender view: SourceViewType) -> Observable<Beacon?>
}

class AddItemWorkflow: AddItemWorkflowType {
    func start(from view: SourceViewType, with type: TrackedItemType) {
        switch type {
            case .other: view.present(R.storyboard.items.addItemNavigation()!, animated: true)
            case .bike: view.present(R.storyboard.items.addBikeNavigation()!, animated: true)
            case .car: view.present(R.storyboard.items.addCarNavigation()!, animated: true)
        }
    }

    func assignBeacon(with beacon: Beacon?, theme: BasicViewTheme, sender view: SourceViewType) -> Observable<Beacon?> {
        guard let assignBeacon = R.storyboard.items.assignBeaconViewController() else {
            fatalError("cannot instantiate controller!")
        }

        assignBeacon.viewModel.beacon.value = beacon
        assignBeacon.viewModel.theme.value = theme
        assignBeacon.viewModel.beaconViewModel.isAssigned.value = beacon != nil
        view.push(assignBeacon, animated: true)

        return assignBeacon.viewModel.completeSignal
    }
}
