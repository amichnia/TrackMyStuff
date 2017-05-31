//
//  Copyright © 2017 GirAppe Studio. All rights reserved.
//

import Foundation
import UIKit
import BTracker

class Car: ItemType {
    var identifier: Identifier
    var beacon: Beacon?
    var motion: CarMotion?

    var icon: ItemIcon
    var name: String { return identifier }
    var plates: String?

    var proximity: Proximity?
    var ranged: Bool = false
    var inMotion: Bool = false

    init(identifier: Identifier, icon: ItemIcon, beacon: Beacon? = nil) {
        self.identifier = identifier
        self.icon = icon
        self.beacon = beacon
        self.motion = CarMotion(car: self)
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
            case .regionDidEnter: ranged = true
            case .regionDidExit: ranged = false
            case .motionDidStart: inMotion = true
            case .motionDidEnd: inMotion = false
            case let .proximityDidChange(proximity): self.proximity = proximity
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
