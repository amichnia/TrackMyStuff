//
// Copyright (c) 2017 GirAppe Studio. All rights reserved.
//

import UIKit

struct BasicViewTheme {
    var background: UIColor
    var foreground: UIColor
    var highlight: UIColor
    var caption: UIColor
    var warning: UIColor
}

extension BasicViewTheme {
    init(backgrounds: UIColor, foregrounds: UIColor, highlights: UIColor? = nil, captions: UIColor? = nil, warnings: UIColor = .red) {
        self = BasicViewTheme(background: backgrounds,
                              foreground: foregrounds,
                              highlight: highlights ?? foregrounds,
                              caption: captions ?? foregrounds,
                              warning: warnings)
    }
}

extension BasicViewTheme {
    static let `default`: BasicViewTheme = BasicViewTheme(backgrounds: .white, foregrounds: .black)
}