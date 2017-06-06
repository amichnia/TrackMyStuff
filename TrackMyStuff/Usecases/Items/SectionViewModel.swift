//
// Copyright (c) 2017 GirAppe Studio. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import BTracker

protocol SectionViewModelType: class {
    var title: String { get }
    var count: Int { get }
    func setup(_ cell: ItemCellType, at indexPath: IndexPath)
}

class SectionViewModel: SectionViewModelType {
    let title: String
    let items: [ItemType]
    var count: Int { return items.count }

    init(title: String, items: [ItemType]) {
        self.items = items
        self.title = title
    }

    func setup(_ cell: ItemCellType, at indexPath: IndexPath) {
        guard let item: ItemType = items[safe: indexPath.row] else { return }

        cell.name = item.name
        cell.icon = item.icon
        item.proximity --> cell.proximity >>> cell.bag
        item.ranged --> cell.isRanged >>> cell.bag
        item.inMotion --> cell.isInMotion >>> cell.bag
        item.location.asObservable().map({ $0 != nil }) --> cell.isLocationAvailable >>> cell.bag
        cell.isTracked.value = item.isTracking.value
        cell.isTracked.asObservable() --> item.isTracking >>> cell.bag
        item.trackDate.asObservable() --> cell.lastSpotDate >>> cell.bag
    }
}
