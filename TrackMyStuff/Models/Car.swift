//
//  Copyright © 2017 GirAppe Studio. All rights reserved.
//

import UIKit
import BTracker
import RxSwift

struct CarMotion: Trackable {
    let identifier: Identifier
    var trackedBy: TrackType { return .movement(type: .driving) }

    init?(car: Car) {
        guard !(car.beacon?.isMotion ?? false) else { return nil } // TODO: Verify if motion should be off
        self.identifier = car.identifier
    }

    func matches(any identifier: Identifier) -> Bool {
        return identifier == self.identifier
    }

    func deliver(event: TrackEvent) { }
}

class Car: BaseItem {
    var motion: CarMotion?

    required init?(identifier: Identifier, icon: ItemIcon, beacon: Beacon? = nil) {
        super.init(identifier: identifier, icon: icon, beacon: beacon)

        self.motion = CarMotion(car: self)
        setupBindings()
    }

    private func setupBindings() {
        // TODO: Additional bindings for car motion?
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
