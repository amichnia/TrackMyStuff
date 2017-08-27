//
//  PageView.swift
//  TrackMyStuff
//
//  Created by Andrzej Michnia on 27.08.2017.
//  Copyright © 2017 GirAppe Studio. All rights reserved.
//

import UIKit

public protocol PageView: class {
    var frame: CGRect { get }
    var view: UIView! { get }
}

public extension PageView {
    var frame: CGRect { return view.frame }
}

extension UIViewController: PageView { }
