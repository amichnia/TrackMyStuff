//
// Copyright (c) 2017 GirAppe Studio. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol ItemCellType: class {
    var name: String? { get set }
    var icon: ItemIcon? { get set }
    var locationHandler: VoidCompletionBlock? { get set }
    var radarhandler: VoidCompletionBlock? { get set }

    var bag: DisposeBag { get }
    var proximity: Variable<Double?> { get }
    var isTracked: Variable<Bool> { get }
    var isRanged: Variable<Bool> { get }
    var isInMotion: Variable<Bool> { get }
    var isLocationAvailable: Variable<Bool> { get }
    var lastSpotDate: Variable<Date?> { get }
}

class ItemCell: UITableViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var proximityLabel: UILabel!
    @IBOutlet weak var proximityProgressView: UIProgressView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var trackingSwitch: UISwitch!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var radarButton: UIButton!
    @IBOutlet weak var motionButton: UIButton!

    var bag: DisposeBag = DisposeBag()
    var proximity = Variable<Double?>(nil)
    var isTracked = Variable<Bool>(false)
    var isRanged = Variable<Bool>(false)
    var isInMotion = Variable<Bool>(false)
    var isLocationAvailable = Variable<Bool>(false)
    var lastSpotDate = Variable<Date?>(nil)

    var locationHandler: VoidCompletionBlock?
    var radarhandler: VoidCompletionBlock?

    override func awakeFromNib() {
        super.awakeFromNib()

        setupBindings()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        locationHandler = nil
        radarhandler = nil
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

        trackingSwitch.rx.isOn <-> isTracked >>> bag

        isRanged.asObservable().bind(to: radarButton.rx.isEnabled) >>> bag
        isRanged.asObservable().bind(to: motionButton.rx.isEnabled) >>> bag
        isLocationAvailable.asObservable().bind(to: locationButton.rx.isEnabled) >>> bag
        isInMotion.asObservable().bind(to: motionButton.rx.isSelected) >>> bag

        lastSpotDate.asObservable().map {
            if let value = $0 {
                return "Last spotted \(value)"
            } else {
                return "Never ranged"
            }
        }.bind(to: infoLabel.rx.text) >>> bag
    }

    @IBAction func map(_ sender: Any) {
        locationHandler?()
    }

    @IBAction func radar(_ sender: Any) {
        radarhandler?()
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
            proximityProgressView.tintColor = newValue.color.counterHighlighted
            nameLabel.textColor = newValue.font.color
            proximityLabel.textColor = newValue.font.color
            backgroundColor = newValue.color
            trackingSwitch.onTintColor = newValue.color.counterHighlighted
            locationButton.tintColor = newValue.color.counterHighlighted
            radarButton.tintColor = newValue.color.counterHighlighted
            motionButton.tintColor = newValue.color.counterHighlighted
        }
    }
}
