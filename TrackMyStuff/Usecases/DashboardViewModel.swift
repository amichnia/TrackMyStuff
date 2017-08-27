//
// Copyright (c) 2017 GirAppe Studio. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol DashboardViewModelType: class {
    var items: Driver<[ItemDetailsViewModelType]> { get }
}

class DashboardViewModel {
    var itemViewModels = Variable<[ItemDetailsViewModelType]>([])

    let workflow: MainWorkflowType

    init(workflow: MainWorkflowType) {
        self.workflow = workflow

        self.itemViewModels.value = [
            ItemDetailsViewModel(title: "Item 1"),
            ItemDetailsViewModel(title: "Some Item 2"),
            ItemDetailsViewModel(title: "O3"),
            ItemDetailsViewModel(title: "Another Item 4")
        ]
    }
}

extension DashboardViewModel: DashboardViewModelType {
    var items: Driver<[ItemDetailsViewModelType]> { return itemViewModels.asDriver() }
}
