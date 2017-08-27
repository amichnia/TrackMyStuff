//
//  Copyright (c) 2017 GirAppe Studio. All rights reserved.
//

import UIKit
import Swinject

@UIApplicationMain
class AppDelegate: UIResponder {
    var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
    var workflow: MainWorkflowType!
    var assembler: Assembler = {
        let assemblerInstance = Assembler()
        assemblerInstance.apply(assemblies: [
            DashboardAssembly()
        ])
        return assemblerInstance
    }()

    override init() {
        super.init()
        workflow = assembler.resolver.resolve(MainWorkflowType.self)!
    }
}

extension AppDelegate: UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        workflow.start(window: window!)
        window?.makeKeyAndVisible()

        return true
    }
}
