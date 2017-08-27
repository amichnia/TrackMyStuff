//
// Copyright (c) 2017 NedBank. All rights reserved.
//

import UIKit

// MARK: - Initializers
public struct Gradient {
    public let style: Gradient.Style
    public let locationsAndColors: [Gradient.LocationAndColor]
    
    public init(style: Style, startColor: UIColor, endColor: UIColor) {
        let start: LocationAndColor = (location: 0, color: startColor)
        let end: LocationAndColor = (location: 1, color: endColor)
        self = Gradient(style: style, locationsAndColors: [start, end])
    }

    public init(style: Style, locationsAndColors: [LocationAndColor]) {
        self.style = style
        self.locationsAndColors = locationsAndColors
    }
}

// MARK: - Definitions
public extension Gradient {
    public typealias LocationAndColor = (location: Double, color: UIColor)

    public enum Style {
        case horizontal
        case vertical
        case diagonal(from: CGPoint, to: CGPoint)

        public typealias GradientPoints = (start: CGPoint, end: CGPoint)
        public var points: GradientPoints {
            switch self {
            case .horizontal: return (CGPoint(x: 0.0, y: 0.5), CGPoint(x: 1.0, y: 0.5))
            case .vertical: return (CGPoint(x: 0.5, y: 0.0), CGPoint(x: 0.5, y: 1.0))
            case let .diagonal(from: from, to: to): return (from, to)
            }
        }
    }
}

// MARK: - Convenience
public extension Gradient {
    var cgGradient: CGGradient? {
        let space = CGColorSpaceCreateDeviceRGB()
        let count = locationsAndColors.count
        let colors = locationsAndColors.map({ $0.color.components }).flatten()
        let locations = locationsAndColors.map { CGFloat($0.location) }

        let gradient = CGGradient(colorSpace: space,
                                  colorComponents: colors,
                                  locations: locations,
                                  count: count)
        return gradient
    }
}

public extension CAGradientLayer {
    func set(gradient: Gradient) {
        self.startPoint = gradient.style.points.start
        self.endPoint = gradient.style.points.end
        self.locations = gradient.locationsAndColors.map { NSNumber(value: $0.location) }
        self.colors = gradient.locationsAndColors.map { $0.color.cgColor }
    }
}

// MARK: - Helpers
fileprivate extension UIColor {
    var components: [CGFloat] {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return [red,green,blue,alpha]
    }
}

fileprivate extension Array {
    func flatten<M>() -> [M] where Element == [M] {
        return self.reduce([]) { (result: [M], v: [M]) -> [M] in
            return result + v
        }
    }
}
