//
//  Copyright © 2017 GirAppe Studio. All rights reserved.
//

import Foundation
import BTracker

struct CarMotion: Trackable {
    let identifier: Identifier
    var trackedBy: TrackType { return .movement(type: .driving) }

    init?(car: Car) {
        guard !(car.beacon?.isMotion ?? false) else { return nil }
        self.identifier = car.identifier
    }

    func matches(any identifier: Identifier) -> Bool {
        return identifier == self.identifier
    }

    func deliver(event: TrackEvent) { }
}
