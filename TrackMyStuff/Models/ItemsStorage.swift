//
// Copyright (c) 2017 GirAppe Studio. All rights reserved.
//

import Foundation
import BTracker
import RxSwift

protocol ItemsStorageType {
    var cars: [Car] { get }
    var bikes: [Bike] { get }
    var other: [Item] { get }
}

class ItemsStorage: ItemsStorageType {
// TODO: Test methods - resolve other way
    private static let testBeacon = Beacon(identifier: "car", proximityUUID: "B9407F30-F5F8-466E-AFF9-25556B57FE6A", major: 33, minor: 33, motionUUID: "39407F30-F5F8-466E-AFF9-25556B57FE6A")
    private static let testCar = Car(identifier: "My Car", icon: Car.icons[0], beacon: ItemsStorage.testBeacon)

    var cars: [Car] {
        ItemsStorage.testCar.tracker = self.tracker
        return [ItemsStorage.testCar]
    }
    var bikes: [Bike] {
        return []
    }
    var other: [Item] {
        return []
    }

    let tracker: TrackingManager

    init(tracker: TrackingManager) {
        self.tracker = tracker
    }
}
