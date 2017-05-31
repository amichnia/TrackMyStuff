//
// Copyright (c) 2017 GirAppe Studio. All rights reserved.
//

import UIKit

protocol AddCarCollectionViewCellType {
    var image: UIImage? { get set }
}

class AddCarCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var carIconImageView: UIImageView!
}

extension AddCarCollectionViewCell: AddCarCollectionViewCellType {
    var image: UIImage? {
        get { return carIconImageView.image }
        set { carIconImageView.image = newValue }
    }
}
