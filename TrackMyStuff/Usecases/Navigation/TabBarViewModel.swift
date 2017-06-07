//
// Copyright (c) 2017 GirAppe Studio. All rights reserved.
//

import Foundation
import RxSwift
import BTracker

enum Tab: Int {
    case items = 0
    case map
    case radar
}

protocol TabBarViewModelType: class {
    var currentTab: Variable<Tab> { get }

    func start(sender: SourceViewType)
    func set(tab: Tab)
}

class TabBarViewModel: TabBarViewModelType {
    var currentTab = Variable<Tab>(.items)

    let tracker: TrackingManager
    let storage: ItemsStorageType
    let workflow: MainWorkflowType

    init(workflow: MainWorkflowType, storage: ItemsStorageType, tracker: TrackingManager) {
        self.workflow = workflow
        self.tracker = tracker
        self.storage = storage
        workflow.tabBarViewModel = self
    }

    func start(sender: SourceViewType) {
        if storage.cars.value.isEmpty {
            workflow.addItemWorkflow.start(from: sender, with: .car)
        }

        tracker.start()
    }

    func set(tab: Tab) {
        currentTab.value = tab
    }
}
