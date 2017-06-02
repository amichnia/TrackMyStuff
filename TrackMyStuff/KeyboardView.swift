//
// Copyright (c) 2017 GirAppe Studio. All rights reserved.
//

import UIKit
import SnapKit

class KeyboardView: UIView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func setup() {
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardView.keyboardChangeFrame(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardView.keyboardChangeFrame(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.snp.makeConstraints({ $0.height.equalTo(0) })
        self.backgroundColor = UIColor.clear
    }

    func keyboardChangeFrame(notification: NSNotification) {
        guard let superview = self.superview else { return }
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        guard let animationCurveInt = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? Int else { return }
        guard let animationCurve = UIViewAnimationCurve(rawValue: animationCurveInt) else { return }
        guard let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double else { return }

        let keyboardEndFrame = superview.convert(keyboardFrame, to: nil)
        var height = keyboardEndFrame.height
        if superview.frame.intersection(keyboardEndFrame).height == 0 { height = 0 }
        self.snp.updateConstraints({ $0.height.equalTo(height) })

        self.setNeedsUpdateConstraints()
        self.setNeedsLayout()

        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(animationDuration)
        UIView.setAnimationCurve(animationCurve)
        UIView.setAnimationBeginsFromCurrentState(true)

        superview.layoutIfNeeded()
        UIView.commitAnimations()
    }
}
