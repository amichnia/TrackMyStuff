//
// Copyright (c) 2017 GirAppe Studio. All rights reserved.
//

import UIKit

struct ButtonTheme {
    static var `default` = ButtonTheme()

    var icon: Icon?
    var fontStyle: FontStyle?
    var backgroundColor: UIColor?

    var normal: ButtonStateTheme?
    var highlighted: ButtonStateTheme?
    var disabled: ButtonStateTheme?
    var selected: ButtonStateTheme?

    init(icon: Icon? = nil, normal: ButtonStateTheme? = nil, highlighted: ButtonStateTheme? = nil, disabled: ButtonStateTheme? = nil, selected: ButtonStateTheme? = nil) {
        self.icon = icon
        self.normal = normal
        self.highlighted = highlighted
        self.disabled = disabled
        self.selected = selected
    }

    struct ButtonStateTheme {
        var titleColor: UIColor?
        var backgroundImage: UIImage?

        init(titleColor: UIColor? = nil, backgroundImage: UIImage? = nil) {
            self.titleColor = titleColor
            self.backgroundImage = backgroundImage
        }
    }

}

extension UIButton {
    func set(theme: ButtonTheme) {
        icon = theme.icon
        titleLabel?.font = theme.fontStyle?.font
        backgroundColor = theme.backgroundColor

        set(theme: theme.normal, for: .normal)
        set(theme: theme.highlighted, for: .highlighted)
        set(theme: theme.disabled, for: .disabled)
        set(theme: theme.selected, for: .selected)
    }

    private func set(theme: ButtonTheme.ButtonStateTheme?, for state: UIControlState) {
        setBackgroundImage(theme?.backgroundImage, for: state)
        setTitleColor(theme?.titleColor, for: state)
    }
}
