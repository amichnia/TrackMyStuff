//
// Copyright (c) 2017 GirAppe Studio. All rights reserved.
//

import UIKit
import BTracker
import RxSwift

enum TrackedItemType: String {
    case other
    case bike
    case car

    init(item: ItemType) {
        if item is Car {
            self = .car
        } else if item is Bike {
            self = .bike
        } else {
            self = .other
        }
    }
}

class BaseItem: ItemType {
    var identifier: Identifier
    var beacon: Beacon?

    var icon: ItemIcon
    var name: String { return identifier }

    var proximity = Variable<Proximity?>(nil)
    var ranged = Variable<Bool>(false)
    var inMotion = Variable<Bool>(false)
    var isTracking = Variable<Bool>(false)
    var trackDate = Variable<Date?>(nil)
    var location = Variable<Location?>(nil)

    let bag = DisposeBag()
    weak var tracker: TrackingManager?

    required init?(identifier: Identifier, icon: ItemIcon, beacon: Beacon? = nil) {
        self.identifier = identifier
        self.icon = icon
        self.beacon = beacon

        setupBindings()
    }

    private func setupBindings() {
        ranged.asObservable().filter({ !$0 }).map({ Bool -> Proximity? in return nil }) --> proximity >>> bag
        ranged.asObservable().subscribe(onNext: { ranged in
                    print("\(self.identifier) ranged \(ranged)")
                }) >>> bag
        proximity.asObservable().subscribe(onNext: { proximity in
                    print("\(self.identifier) proximity \(proximity ?? -1)")
                }) >>> bag

        isTracking.asObservable().subscribe(onNext: { tracking in
                    if tracking {
                        self.startTracking()
                    } else {
                        self.stopTracking()
                    }
                }) >>> bag
    }

    func startTracking() {
        guard let tracker = tracker else { return }
        tracker.track(self)
    }

    func stopTracking() {
        ranged.value = false
        guard let tracker = tracker else { return }
        tracker.stop(tracking: self)
    }
}

extension BaseItem: MultiTrackable {
    var trackedBy: [Trackable] {
        return beacon.toArray
    }

    func delivered(event: TrackEvent, by trackable: Trackable) {
        switch event {
        case .regionDidEnter:
            ranged.value = true
        case .regionDidExit:
            ranged.value = false
        case .motionDidStart:
            inMotion.value = true
        case .motionDidEnd:
            inMotion.value = false
            location.value = Location(location: tracker?.currentLocation)
        case let .proximityDidChange(value) where value ?? -1 >= 0:
            proximity.value = value
        default:
            break
        }
    }
}
