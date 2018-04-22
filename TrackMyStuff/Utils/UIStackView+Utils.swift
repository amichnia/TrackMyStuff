//
// Copyright (c) 2017 GirAppe Studio. All rights reserved.
//

import UIKit

extension UIStackView {
    public func clear() {
        arrangedSubviews.forEach {
            $0.removeFromSuperview()
            removeArrangedSubview($0)
        }
    }

    public func clear(but views: [UIView]) {
        arrangedSubviews.forEach { view in
            guard !views.contains(where: { $0 == view }) else {
                return
            }
            view.removeFromSuperview()
            removeArrangedSubview(view)
        }
    }

    public func add(_ view: UIView) {
        addSubview(view)
        addArrangedSubview(view)
    }
}
