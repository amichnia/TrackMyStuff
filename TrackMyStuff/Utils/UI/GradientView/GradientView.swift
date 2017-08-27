//
//  GradientView.swift
//  NedBankApp
//
//  Created by Andrzej Michnia on 20.07.2017.
//  Copyright © 2017 NedBank. All rights reserved.
//

import UIKit

public struct Gradients {
    public static var dashboard: Gradient {
        let start = UIColor.clear
        let end = UIColor.black.withAlphaComponent(0.97)
        return Gradient(style: .vertical, startColor: start, endColor: end)
    }
}

public class GradientView: UIView {
    private enum GradientType: String {
        case dashboard

        var gradient: Gradient {
            switch self {
            case .dashboard: return Gradients.dashboard
            }
        }
    }

    @IBInspectable var gradientName: String = "dashboard" {
        didSet {
            gradient = GradientType(rawValue: gradientName)?.gradient ?? gradient
        }
    }
    public var gradient = Gradients.dashboard {
        didSet { setNeedsDisplay() }
    }

    public override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        guard let cgGradient = gradient.cgGradient else { return }

        let options = CGGradientDrawingOptions.init(rawValue: 0)
        let start = CGPoint.zero
        let end = CGPoint(x: 0, y: rect.height)
        context.drawLinearGradient(cgGradient, start: start, end: end, options: options)
    }
}
