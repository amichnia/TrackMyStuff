//
// Copyright (c) 2017 GirAppe Studio. All rights reserved.
//

import UIKit

protocol AddItemCollectionViewCellType: class {
    var image: UIImage? { get set }
}

class AddItemCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var carIconImageView: UIImageView!
}

extension AddItemCollectionViewCell: AddItemCollectionViewCellType {
    var image: UIImage? {
        get { return carIconImageView.image }
        set { carIconImageView.image = newValue }
    }
}
