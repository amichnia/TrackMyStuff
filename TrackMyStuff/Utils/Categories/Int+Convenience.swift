//
// Copyright (c) 2017 GirAppe Studio. All rights reserved.
//

import Foundation

extension Int {
    init?(text: String?) {
        guard let text = text else { return nil }
        self.init(text)
    }
}
