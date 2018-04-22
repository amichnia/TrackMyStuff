//
// Copyright (c) 2017 GirAppe Studio. All rights reserved.
//

import UIKit

struct FontStyle {
    var descriptor: UIFontDescriptor
    var color: UIColor
    var size: CGFloat?

    var font: UIFont {
        return UIFont(descriptor: descriptor, size: size ?? descriptor.pointSize)
    }

    init(descriptor: UIFontDescriptor, color: UIColor, size: CGFloat? = nil) {
        self.descriptor = descriptor
        self.color = color
        self.size = size
    }

    init(style: UIFontTextStyle, color: UIColor) {
        self.descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
        self.color = color
    }

    @available(iOS 10.0, *)
    init(style: UIFontTextStyle, color: UIColor, compatibleWith traitCollection: UITraitCollection?) {
        self.descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style, compatibleWith: traitCollection)
        self.color = color
    }
}

extension  FontStyle {
    static var `default` = FontStyle(descriptor: UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body), color: UIColor.black)

    static func `default`(with color: UIColor) -> FontStyle {
        return FontStyle(style: .body, color: color)
    }
}

extension UILabel {
    func set(style: FontStyle?) {
        font = style?.font
        textColor = style?.color
    }
}
