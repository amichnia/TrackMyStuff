//
// Copyright (c) 2017 GirAppe Studio. All rights reserved.
//

import UIKit
import RxSwift
import Swinject
import SwinjectStoryboard
import BTracker

protocol AddCarWorkflowType: class, AnyWorkflowType {
    func start(from view: SourceViewType)
    func assignBeacon(with beacon: Beacon?, theme: BasicViewTheme, sender view: SourceViewType) -> Observable<Beacon?>
}

class AddCarWorkflow: AddCarWorkflowType {
    func start(from view: SourceViewType) {
        guard let addCarNavigation = R.storyboard.items.addCarNavigation() else {
            fatalError("cannot instantiate controller!")
        }
        view.present(addCarNavigation, animated: true)
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
