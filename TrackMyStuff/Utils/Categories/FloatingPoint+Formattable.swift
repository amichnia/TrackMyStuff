import Foundation
import CoreGraphics

// MARK: - Formatting Debug Description
/// Can return self as formatted String
internal protocol Formattable {
    func format(_ f: String) -> String
}

internal extension Array where Element: Formattable {
    /// For Debug - formats array of **Formattable** elements for print purposes.
    ///
    /// - Parameter f: format string
    /// - Returns: formatted string
    func formatted(_ f: String) -> String {
        let inner: String = self.reduce("") { inner, element in
            return "\(inner),\(element.format(f))"
        }
        return "[\(inner)]"
    }

}

extension Int: Formattable {
    /// Formats Int as string
    ///
    /// - Parameter f: format string
    /// - Returns: formatted string
    func format(_ f: String) -> String {
        return String(format: "%\(f)d", self)
    }
}

extension Double: Formattable {
    /// Formats Double as string
    ///
    /// - Parameter f: format string
    /// - Returns: formatted string
    func format(_ f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}

extension Float: Formattable {
    /// Formats Double as string
    ///
    /// - Parameter f: format string
    /// - Returns: formatted string
    func format(_ f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}


extension CGFloat: Formattable {
    /// Formats Double as string
    ///
    /// - Parameter f: format string
    /// - Returns: formatted string
    func format(_ f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}
