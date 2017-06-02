//
// Copyright (c) 2017 GirAppe Studio. All rights reserved.
//

import UIKit

class PassthroughView: UIView {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard let _ = subviews.first(where: { $0.isUserInteractionEnabled && $0.point(inside: self.convert(point, to: $0), with: event) }) else {
            return false
        }

        return true
    }
}
