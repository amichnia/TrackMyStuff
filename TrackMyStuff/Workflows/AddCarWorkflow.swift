//
// Copyright (c) 2017 GirAppe Studio. All rights reserved.
//

import UIKit
import RxSwift
import Swinject
import SwinjectStoryboard

protocol AddCarWorkflowType: class, AnyWorkflowType {
    func start(from view: SourceViewType)
}

class AddCarWorkflow: AddCarWorkflowType {
    func start(from view: SourceViewType) {
        guard let addCarNavigation = R.storyboard.addCarStoryboard.instantiateInitialViewController() else {
            fatalError("cannot instantiate controller!")
        }
        view.present(addCarNavigation, animated: true)
    }
}
