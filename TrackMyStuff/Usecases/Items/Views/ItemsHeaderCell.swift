//
// Copyright (c) 2017 GirAppe Studio. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol ItemHeaderCellType: class {
    var title: String? { get set }
    var addHandler: (() -> Void)? { get set }
}

class ItemHeaderCell: UITableViewCell, ItemHeaderCellType {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!

    var addHandler: (() -> Void)?
    var title: String? {
        get { return titleLabel.text }
        set { titleLabel.text = newValue }
    }

    @IBAction func addAction(_ sender: Any) {
        addHandler?()
    }
}
