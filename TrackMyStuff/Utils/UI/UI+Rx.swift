//
// Copyright (c) 2017 GirAppe Studio. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base : UIView {
    public var backgroundColor: RxCocoa.UIBindingObserver<Base, UIColor> {
        return UIBindingObserver<Base, UIColor>(UIElement: base, binding: { (view: Base, color: UIColor) in
            view.backgroundColor = color
        })
    }
    public var tintColor: RxCocoa.UIBindingObserver<Base, UIColor> {
        return UIBindingObserver<Base, UIColor>(UIElement: base, binding: { (view: Base, color: UIColor) in
            view.tintColor = color
        })
    }
}

extension Reactive where Base : UILabel {
    public var textColor: RxCocoa.UIBindingObserver<Base, UIColor> {
        return UIBindingObserver<Base, UIColor>(UIElement: base, binding: { (view: Base, color: UIColor) in
            view.textColor = color
        })
    }
}

extension Reactive where Base : UITextField {
    public var textColor: RxCocoa.UIBindingObserver<Base, UIColor> {
        return UIBindingObserver<Base, UIColor>(UIElement: base, binding: { (view: Base, color: UIColor) in
            view.textColor = color
        })
    }
}

extension Reactive where Base : UIBarButtonItem {
    public var tintColor: RxCocoa.UIBindingObserver<Base, UIColor> {
        return UIBindingObserver<Base, UIColor>(UIElement: base, binding: { (view: Base, color: UIColor) in
            view.tintColor = color
        })
    }
}

extension Reactive where Base : UINavigationBar {
    public var barTintColor: RxCocoa.UIBindingObserver<Base, UIColor> {
        return UIBindingObserver<Base, UIColor>(UIElement: base, binding: { (view: Base, color: UIColor) in
            view.barTintColor = color
        })
    }
    public var titleColor: RxCocoa.UIBindingObserver<Base, UIColor> {
        return UIBindingObserver<Base, UIColor>(UIElement: base, binding: { (view: Base, color: UIColor) in
            view.titleTextAttributes = [NSForegroundColorAttributeName: color]
        })
    }
}

extension Reactive where Base : UIButton {
    public func titleColor(for state: UIControlState = .normal) -> RxCocoa.UIBindingObserver<Base, UIColor> {
        return UIBindingObserver<Base, UIColor>(UIElement: base, binding: { (view: Base, color: UIColor) in
            view.setTitleColor(color, for: state)
        })
    }
}
