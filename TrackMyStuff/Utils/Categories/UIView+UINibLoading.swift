import UIKit

@objc protocol UINibLoading {}
extension UIView : UINibLoading {}

extension UINibLoading where Self : UIView {
    static var defaultNibName: String {
        return String(describing: self)
    }

    // note that this method returns an instance of type `Self`, rather than UIView
    static func loadFromNib() -> Self {
        return loadFromNibNamed(nibName: defaultNibName)
    }

    // note that this method returns an instance of type `Self`, rather than UIView
    static func loadFromNibNamed(nibName: String) -> Self {
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as! Self
    }
}
