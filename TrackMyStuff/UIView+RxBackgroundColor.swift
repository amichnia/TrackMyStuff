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
}
