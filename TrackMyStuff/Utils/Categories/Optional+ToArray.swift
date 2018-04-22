//
//  Copyright © 2017 GirAppe Studio. All rights reserved.
//

import Foundation

extension Optional {
    var toArray: [Wrapped] {
        guard let value = self else { return [] }
        return  [value]
    }
}
