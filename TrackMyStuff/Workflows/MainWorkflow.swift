import UIKit
import RxSwift
import Swinject
import SwinjectStoryboard

protocol MainWorkflowType: class, AnyWorkflowType {
    var tabBarViewModel: TabBarViewModelType! { get set }
    var selectedItem: Variable<ItemType?> { get }

    // TODO: Child workflows here
    var itemsWorkflow: ItemsWorkflowType! { get set }
    var addItemWorkflow: AddItemWorkflowType! { get set }

    func start(window: UIWindow)
    func showLocation(for item: ItemType)
}

class MainWorkflow: MainWorkflowType {
    var itemsWorkflow: ItemsWorkflowType!
    var addItemWorkflow: AddItemWorkflowType!

    weak var tabBarViewModel: TabBarViewModelType!
    var selectedItem = Variable<ItemType?>(nil)

    func start(window: UIWindow) {
        guard let viewController = UIStoryboard(name: "Dashboard", bundle: nil).instantiateInitialViewController() else {
            assertionFailure("Cannot instantinate initial view controller!")
            return
        }
        window.setRootViewController(newRoot: viewController)
    }

    func showLocation(for item: ItemType) {
        tabBarViewModel.set(tab: .map)
        selectedItem.value = item
    }
}
