import UIKit

protocol SourceViewType: class {
    var presentingView: SourceViewType? { get }
    var presentedView: SourceViewType? { get }
    var handleError: (Error) -> Void { get }

    func push(_ view: SourceViewType, animated: Bool)
    func pop(animated: Bool)
    func popToLastViewControllerOfClass(_ viewControllerClass: UIViewController.Type, animated: Bool)
    func present(_ view: SourceViewType, animated flag: Bool)
    func present(_ view: SourceViewType, animated flag: Bool, completion: (() -> Swift.Void)?)
    func present(error: Error)
    func dismiss(animated flag: Bool)
    func dismiss(animated flag: Bool, completion: (() -> Swift.Void)?)
}

extension SourceViewType {
    func dismiss(animated flag: Bool) {
        dismiss(animated: flag, completion: nil)
    }
}

extension UIViewController: SourceViewType {
    var controller: UIViewController { return self }
    var presentingView: SourceViewType? {
        return presentingViewController ?? navigationController?.presentingViewController
    }
    var presentedView: SourceViewType? {
        return presentedViewController ?? navigationController?.presentedViewController
    }
    var handleError: (Error) -> Void {
        return { [weak self] error in
            self?.present(error: error)
        }
    }

    func push(_ view: SourceViewType, animated: Bool) {
        guard let viewController = view as? UIViewController else { return }
        ((self as? UINavigationController) ?? navigationController)?.pushViewController(viewController, animated: true)
    }

    func pop(animated: Bool) {
        _ = navigationController?.popViewController(animated: animated)
    }

    func popToLastViewControllerOfClass(_ viewControllerClass: UIViewController.Type, animated: Bool) {
        guard let navigationController = self.navigationController, navigationController.viewControllers.count > 1 else { return }
        for viewController in navigationController.viewControllers.reversed() {
            if viewController.isKind(of: viewControllerClass) {
                navigationController.popToViewController(viewController, animated: animated)
                break
            }
        }
    }

    func present(_ view: SourceViewType, animated flag: Bool) {
        present(view, animated: flag, completion: nil)
    }

    func present(_ view: SourceViewType, animated flag: Bool, completion: (() -> Void)?) {
        guard let viewController = view as? UIViewController else { return }
        present(viewController, animated: flag, completion: completion)
    }

    func present(error: Error) {
        let alert = UIAlertController(title: nil, message: String(describing: error), preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: nil)
    }
}
