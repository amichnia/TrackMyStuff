//
// Copyright (c) 2017 GirAppe Studio. All rights reserved.
//

import UIKit
import Rswift

@objc public protocol UINibLoading {}
extension UIView : UINibLoading {}

extension UINibLoading where Self : UIView {
    public static func load(from nib: UINib) -> Self {
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? Self else {
            fatalError("Could not instantiate \(self)")
        }
        return view
    }

    public static func loadFromNib(`in` bundle: Bundle? = nil) -> Self {
        let bundle = bundle ?? Bundle(for: self)
        let nibName = "\(self)".characters.split {$0 == "."}.map(String.init).last ?? String(describing: self)
        let nib = UINib(nibName: nibName, bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? Self else {
            fatalError("Could not instantiate \(self)")
        }
        return view
    }

    public static func loadFromNibNamed(nibName: String, `in` bundle: Bundle? = nil) -> Self {
        let bundle = bundle ?? Bundle(for: self)
        let nib = UINib(nibName: nibName, bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? Self else {
            fatalError("Could not instantiate \(self)")
        }
        return view
    }
}
