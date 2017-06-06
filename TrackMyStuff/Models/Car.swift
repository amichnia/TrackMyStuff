//
//  Copyright © 2017 GirAppe Studio. All rights reserved.
//

import UIKit
import BTracker
import RxSwift

class Car: ItemType {
    var identifier: Identifier
    var beacon: Beacon?
    var motion: CarMotion?

    var icon: ItemIcon
    var name: String { return identifier }
    var plates: String?

    var proximity = Variable<Proximity?>(nil)
    var ranged = Variable<Bool>(false)
    var inMotion = Variable<Bool>(false)
    var isTracking = Variable<Bool>(false)
    var trackDate = Variable<Date?>(nil)
    var location = Variable<Location?>(nil)

    let bag = DisposeBag()
    weak var tracker: TrackingManager?

    init(identifier: Identifier, icon: ItemIcon, beacon: Beacon? = nil) {
        self.identifier = identifier
        self.icon = icon
        self.beacon = beacon
        self.motion = CarMotion(car: self)

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
}

extension Car {
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

extension Car: MultiTrackable {
    var trackedBy: [Trackable] {
        let beaconArray: [Trackable] = beacon.toArray
        let motionArray: [Trackable] = motion.toArray
        return beaconArray + motionArray
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

extension Car {
    static var icons: [ItemIcon] {
        return [
            ItemIcon(image: R.image.car.car0()!, color: .hansaYellow, font: .default(with: UIColor.text.dark)),
            ItemIcon(image: R.image.car.car1()!, color: .pistachio, font: .default(with: UIColor.text.dark)),
            ItemIcon(image: R.image.car.car2()!, color: .englishVermillion, font: .default(with: UIColor.text.veryLight)),
            ItemIcon(image: R.image.car.car3()!, color: .indianYellow, font: .default(with: UIColor.text.dark)),
            ItemIcon(image: R.image.car.car4()!, color: .darkSkyBlue, font: .default(with: UIColor.text.dark)),
            ItemIcon(image: R.image.car.car5()!, color: .aspargus, font: .default(with: UIColor.text.dark))
        ]
    }
}
