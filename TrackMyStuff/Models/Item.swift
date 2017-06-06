//
//  Copyright © 2017 GirAppe Studio. All rights reserved.
//

import UIKit
import BTracker
import RxSwift

class Item: BaseItem { }

extension Item {
    static var icons: [ItemIcon] {
        return [
            ItemIcon(image: R.image.stuff.key0()!, color: UIColor.stuff.keyBlue, font: .default(with: UIColor.text.veryLight)),
            ItemIcon(image: R.image.stuff.key1()!, color: UIColor.stuff.keyRed, font: .default(with: UIColor.text.dark)),
            ItemIcon(image: R.image.stuff.wallet0()!, color: UIColor.stuff.walletYellow, font: .default(with: UIColor.text.dark)),
            ItemIcon(image: R.image.stuff.wallet1()!, color: UIColor.stuff.walletGreen, font: .default(with: UIColor.text.veryLight)),
            ItemIcon(image: R.image.stuff.purse()!, color: UIColor.stuff.purseOrange, font: .default(with: UIColor.text.dark)),
            ItemIcon(image: R.image.stuff.backpack0()!, color: UIColor.stuff.backpackGreen, font: .default(with: UIColor.text.veryLight)),
            ItemIcon(image: R.image.stuff.case0()!, color: UIColor.stuff.briefcaseGray, font: .default(with: UIColor.text.veryLight)),
            ItemIcon(image: R.image.stuff.unknown()!, color: UIColor.stuff.unknownYellow, font: .default(with: UIColor.text.dark)),
        ]
    }
}
