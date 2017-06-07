//
//  Copyright © 2017 GirAppe Studio. All rights reserved.
//

import UIKit
import BTracker
import RxSwift

struct BikeMotion: Trackable {
    let identifier: Identifier
    var trackedBy: TrackType { return .movement(type: .cycling) }

    init?(bike: Bike) {
        guard !(bike.beacon?.isMotion ?? false) else { return nil } // TODO: Verify if motion should be off
        self.identifier = bike.identifier
    }

    func matches(any identifier: Identifier) -> Bool {
        return identifier == self.identifier
    }

    func deliver(event: TrackEvent) { }
}

class Bike: BaseItem {
    var motion: BikeMotion?

    required init?(identifier: Identifier, icon: ItemIcon, beacon: Beacon? = nil) {
        super.init(identifier: identifier, icon: icon, beacon: beacon)

        self.motion = BikeMotion(bike: self)
        setupBindings()
    }

    private func setupBindings() {
        // TODO: Additional bindings for bike motion?
    }
}

extension Bike {
    static var icons: [ItemIcon] {
        return [
            ItemIcon(image: R.image.bike.bike0()!, color: UIColor.bike.green, font: .default(with: UIColor.text.veryLight)),
            ItemIcon(image: R.image.bike.bike1()!, color: UIColor.bike.red1, font: .default(with: UIColor.text.dark)),
            ItemIcon(image: R.image.bike.bike2()!, color: UIColor.bike.red2, font: .default(with: UIColor.text.dark)),
        ]
    }
}
