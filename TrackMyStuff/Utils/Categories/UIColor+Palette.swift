//
// Copyright (c) 2017 GirAppe Studio. All rights reserved.
//

import UIKit

extension UIColor {
    static let pistachio            = UIColor(netHex: 0x9ED66F)
    static let aspargus             = UIColor(netHex: 0x87A878)
    static let middleGreen          = UIColor(netHex: 0x4D7358)
    static let eggShell             = UIColor(netHex: 0xEFECCA)
    static let hansaYellow          = UIColor(netHex: 0xE8D174)
    static let indianYellow         = UIColor(netHex: 0xE39E54)
    static let englishVermillion    = UIColor(netHex: 0xD64D4D)
    static let darkSkyBlue          = UIColor(netHex: 0x84C0C6)
    static let cambridgeBlue        = UIColor(netHex: 0x9FB7B9)
    static let shadowBlue           = UIColor(netHex: 0x7180AC)
    static let deepKoamaru          = UIColor(netHex: 0x2B4570)

    struct text {
        static let veryLight        = UIColor(netHex: 0xFAFAFA)
        static let light            = UIColor(netHex: 0xEFECCA)
        static let lightGray        = UIColor(netHex: 0x9FA89A)
        static let gray             = UIColor(netHex: 0x666B63)
        static let darkGray         = UIColor(netHex: 0x2C2E2A)
        static let dark             = UIColor(netHex: 0x151614)
    }
}

extension UIColor {
    convenience init(rgba: (CGFloat, CGFloat, CGFloat, CGFloat)) {
        self.init(red: rgba.0, green: rgba.1, blue: rgba.2, alpha: rgba.3)
    }

    convenience init?(rgbString: String, separator: Character = ",") {
        self.init(rgbaString: rgbString, separator: separator)
    }

    convenience init?(rgbaString: String, separator: Character = ",") {
        let components = rgbaString.characters.split(separator: separator).map(String.init)

        guard components.count == 4 || components.count == 3 else {
            return nil
        }

        guard
                let red = Int(components[0]),
                let green = Int(components[1]),
                let blue = Int(components[2]),
                let alpha = components.count == 4 ? Int(components[3]) : 255
                else {
            return nil
        }

        self.init(red: red, green: green, blue: blue, alphaValue: alpha)
    }

    func randomAbbreviation() -> UIColor {
        var color: (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
        self.getRed(&color.0, green: &color.1, blue: &color.2, alpha: &color.3)

        color.0 += CGFloat(arc4random() % 40 - 20)
        color.1 += CGFloat(arc4random() % 40 - 20)

        return UIColor(rgba: color)
    }
}

extension UIColor {
    static func interpolate(colorA: UIColor, colorB: UIColor, factor: Float) -> UIColor {
        var color1 : (CGFloat,CGFloat,CGFloat,CGFloat) = (0,0,0,0)
        colorA.getRed(&color1.0, green: &color1.1, blue: &color1.2, alpha: &color1.3)

        var color2 : (CGFloat,CGFloat,CGFloat,CGFloat) = (0,0,0,0)
        colorB.getRed(&color2.0, green: &color2.1, blue: &color2.2, alpha: &color2.3)

        var color: (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
        color.0 = CGFloat.interpolate(first: color1.0, second: color2.0, factor: factor)
        color.1 = CGFloat.interpolate(first: color1.1, second: color2.1, factor: factor)
        color.2 = CGFloat.interpolate(first: color1.2, second: color2.2, factor: factor)
        color.3 = CGFloat.interpolate(first: color1.3, second: color2.3, factor: factor)

        return UIColor(rgba: color)
    }
}

fileprivate extension CGFloat {
    static func interpolate(first: CGFloat, second: CGFloat, factor: Float) -> CGFloat {
        return first + ((second - first) * CGFloat(factor))
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    convenience init(red: Int, green: Int, blue: Int, alphaValue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: CGFloat(alphaValue) / 255.0)
    }

    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}
