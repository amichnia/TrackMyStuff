import UIKit

extension UIWindow {
    func setRootViewController(newRoot: UIViewController, animated: Bool = false) {
        if self.rootViewController != nil && animated {
            UIView.transition(with: self, duration: 0.6, options: .transitionCrossDissolve, animations: {
                self.rootViewController = newRoot
            }, completion: nil)
        } else {
            self.rootViewController = newRoot
        }
    }
}
