//
// Copyright (c) 2017 GirAppe Studio. All rights reserved.
//

import UIKit

struct Icon {
    static var empty = Icon()

    var normal: UIImage?
    var selected: UIImage?
    var highlighted: UIImage?

    init(normal: UIImage? = nil, selected: UIImage? = nil, highlighted: UIImage? = nil) {
        self.normal = normal
        self.selected = selected
        self.highlighted = highlighted
    }
}

extension UIImageView {
    var icon: Icon? {
        get {
            return Icon(normal: image, highlighted: highlightedImage)
        }
        set {
            image = newValue?.normal
            highlightedImage = newValue?.highlighted
        }
    }
}

extension UIButton {
    var icon: Icon? {
        get {
            return Icon(normal: image(for: .normal), selected: image(for: .selected), highlighted: image(for: .highlighted))
        }
        set {
            setImage(newValue?.normal, for: .normal)
            setImage(newValue?.selected, for: .selected)
            setImage(newValue?.highlighted, for: .highlighted)
        }
    }
}
