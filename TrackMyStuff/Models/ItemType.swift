//
// Copyright (c) 2017 GirAppe Studio. All rights reserved.
//

import Foundation
import BTracker
import RxSwift
import CoreLocation

protocol ItemType {
    var icon: ItemIcon { get }
    var name: String { get }

    var proximity: Variable<Proximity?> { get }
    var ranged: Variable<Bool> { get }
    var inMotion: Variable<Bool> { get }
    var isTracking: Variable<Bool> { get }
    var trackDate: Variable<Date?> { get }
    var location: Variable<Location?> { get }
}

struct Location {
    let latitude: Double
    let longitude: Double
    let proximity: Proximity
}

extension Location {
    init?(location: CLLocation?) {
        guard let location = location else { return nil }
        self = Location(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, proximity: location.horizontalAccuracy)
    }
}
