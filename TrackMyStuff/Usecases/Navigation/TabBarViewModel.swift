//
// Copyright (c) 2017 GirAppe Studio. All rights reserved.
//

import Foundation
import RxSwift
import BTracker

protocol TabBarViewModelType {
    func start(sender: SourceViewType)
    func addNewCar(start view: SourceViewType)
}

class TabBarViewModel: TabBarViewModelType {
    fileprivate var workflow: MainWorkflowType

    var tracker: TrackingManager
    var storage: ItemsStorageType

    init(workflow: MainWorkflowType, storage: ItemsStorageType, tracker: TrackingManager) {
        self.workflow = workflow
        self.tracker = tracker
        self.storage = storage
    }

    func start(sender: SourceViewType) {
        if storage.cars.isEmpty {
            workflow.addCarWorkflow.start(from: sender)
        }

        tracker.start()

        for car in storage.cars {
            tracker.track(car)
        }
    }

    func addNewCar(start view: SourceViewType) {
        workflow.addCarWorkflow.start(from: view)
    }
}
