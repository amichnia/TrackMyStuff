//
// Copyright (c) 2017 GirAppe Studio. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol ItemDetailsViewModelType: class {
    var title: String { get }
}

class ItemDetailsViewModel: ItemDetailsViewModelType {
    private(set) var title: String = "aaa"

    init(title: String) {
        self.title = title
    }
}