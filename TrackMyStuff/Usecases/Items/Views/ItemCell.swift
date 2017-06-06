//
// Copyright (c) 2017 GirAppe Studio. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol ItemCellType: class {
    var name: String? { get set }
    var icon: ItemIcon? { get set }

    var bag: DisposeBag { get }
    var proximity: Variable<Double?> { get }
}

class ItemCell: UITableViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var proximityLabel: UILabel!
    @IBOutlet weak var proximityProgressView: UIProgressView!

    var bag: DisposeBag = DisposeBag()
    var proximity = Variable<Double?>(nil)

    override func awakeFromNib() {
        super.awakeFromNib()

        setupBindings()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        setupBindings()
    }

    private func setupBindings() {
        bag = DisposeBag()

        proximity.asObservable().map({ (proximity: Double?) -> String in
            if let proximity = proximity {
                return "\(R.string.localizable.meterShort(proximity.format(".0")))"
            } else {
                return R.string.localizable.proximityUnknown()
            }
        }).bind(to: proximityLabel.rx.text) >>> bag

        proximity.asObservable().map({ Float(Swift.max(0, 60 - ($0 ?? 1000)) / 60) }).bind(to: proximityProgressView.rx.progress) >>> bag

        proximity.asObservable().subscribe(onNext: { proximity in
            print("cell update proximity with \(proximity ?? -1)")
        }, onDisposed: {
            print("cell disposes proximity bindings")
        }) >>> bag
    }
}

extension ItemCell: ItemCellType {
    var name: String? {
        get { return nameLabel.text }
        set { nameLabel.text = newValue }
    }
    var icon: ItemIcon? {
        get { return nil }
        set {
            guard let newValue = newValue else { return }
            iconImageView.image = newValue.image
            proximityProgressView.tintColor = newValue.font.color
            nameLabel.textColor = newValue.font.color
            proximityLabel.textColor = newValue.font.color
            backgroundColor = newValue.color
        }
    }
}
