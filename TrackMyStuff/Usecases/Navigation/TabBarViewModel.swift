//
// Copyright (c) 2017 GirAppe Studio. All rights reserved.
//

import Foundation
import RxSwift
import BTracker

protocol TabBarViewModelType {
    func start(sender: SourceViewType)
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
        if storage.cars.value.isEmpty {
            workflow.addItemWorkflow.start(from: sender, with: .car)
        }

        tracker.start()
    }
}
