//
// Copyright (c) 2017 GirAppe Studio. All rights reserved.
//

import Foundation
import BTracker
import RxSwift

protocol ItemsStorageType {
    var cars: Variable<[Car]> { get }
    var bikes: Variable<[Bike]> { get }
    var other: Variable<[Item]> { get }

    func can(add item: BaseItem) -> Bool
    func add(item: BaseItem)
}

class ItemsStorage: ItemsStorageType {
// TODO: Test methods - resolve other way
    private static let testBeacon = Beacon(identifier: "car", proximityUUID: "B9407F30-F5F8-466E-AFF9-25556B57FE6A", major: 33, minor: 33, motionUUID: "39407F30-F5F8-466E-AFF9-25556B57FE6A")
    private static let testCar = Car(identifier: "My Car", icon: Car.icons[0], beacon: ItemsStorage.testBeacon)!

    var cars: Variable<[Car]> = {
        return Variable<[Car]>([ItemsStorage.testCar])
    }()
    var bikes: Variable<[Bike]> = {
        return Variable<[Bike]>([])
    }()
    var other: Variable<[Item]> = {
        return Variable<[Item]>([])
    }()

    let tracker: TrackingManager

    init(tracker: TrackingManager) {
        ItemsStorage.testCar.tracker = tracker
        self.tracker = tracker
    }

    func can(add item: BaseItem) -> Bool {
        return true
    }

    func add(item: BaseItem){
        switch item {
        case is Car: add(car: item as! Car)
        case is Bike: add(bike: item as! Bike)
        case is Item: add(item: item as! Item)
        default: fatalError()
        }
    }

    private func add(car: Car) {
        print("Adding car")
        cars.value = cars.value + [car]
    }
    private func add(bike: Bike) {
        print("Adding bike")
        bikes.value = bikes.value + [bike]
    }
    private func add(item: Item) {
        print("Adding item")
        other.value = other.value + [item]
    }
}
