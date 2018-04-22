import UIKit
import RxSwift
import RxCocoa

typealias BarButtonItemActionHandler = (() -> Void)

class BaseViewController: UIViewController {
    let bag = DisposeBag()
    var closeHandler: BarButtonItemActionHandler?

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    func addRightItem(item: UIBarButtonItem) {
        var items = navigationItem.rightBarButtonItems ?? []
        items.append(item)
        navigationItem.rightBarButtonItems = items
    }

    func addLeftItem(item: UIBarButtonItem) {
        var items = navigationItem.leftBarButtonItems ?? []
        items.append(item)
        navigationItem.leftBarButtonItems = items
    }

    func closeBarButtonItem() -> UIBarButtonItem {
        let item = barButtonItem(icon: Icon(normal: R.image.icon.close()))
        item.target = self
        item.action = #selector(closeAction)
        return item
    }

    private func barButtonItem(icon: Icon) -> UIBarButtonItem {
        let item = UIBarButtonItem(image: icon.normal, style: .plain, target: nil, action: nil)
        return item
    }

    @IBAction func closeAction() {
        closeHandler?()
    }
}
