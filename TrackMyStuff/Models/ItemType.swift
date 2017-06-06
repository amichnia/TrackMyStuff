//
// Copyright (c) 2017 GirAppe Studio. All rights reserved.
//

import Foundation
import BTracker
import RxSwift

protocol ItemType {
    var icon: ItemIcon { get }
    var name: String { get }

    var proximity: Variable<Proximity?> { get }
    var ranged: Variable<Bool> { get }
    var inMotion: Variable<Bool> { get }
//    var location: Variable<Location> { get } // TODO: Add location for map purpose
}
