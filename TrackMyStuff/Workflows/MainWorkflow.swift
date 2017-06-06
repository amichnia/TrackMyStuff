import UIKit
import RxSwift
import Swinject
import SwinjectStoryboard

protocol MainWorkflowType: class, AnyWorkflowType {
    // TODO: Child workflows here
    var itemsWorkflow: ItemsWorkflowType! { get set }
    var addCarWorkflow: AddCarWorkflowType! { get set }

    func start(window: UIWindow)
}

class MainWorkflow: MainWorkflowType {
    var itemsWorkflow: ItemsWorkflowType!
    var addCarWorkflow: AddCarWorkflowType!

    func start(window: UIWindow) {
        guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() else {
            assertionFailure("Cannot instantinate initial view controller!")
            return
        }
        window.setRootViewController(newRoot: viewController)
    }
}
