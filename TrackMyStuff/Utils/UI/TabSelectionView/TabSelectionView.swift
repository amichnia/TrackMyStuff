//
//  Copyright © 2017 NedBank. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TabSelectionView: UIScrollView {
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var indicatorView: UIView!
    @IBInspectable var marginLeft: CGFloat = 10 { didSet { updateUI() } }
    @IBInspectable var marginRight: CGFloat = 10 { didSet { updateUI() } }

    var bag = DisposeBag()
    var selection = Variable<Int?>(nil)
    var tiles: [TabTileView] = []

    lazy var indicator: CAShapeLayer = {
        let layer = CAShapeLayer.indicator()
        self.indicatorView.layer.addSublayer(layer)
        return layer
    }()

    override func layoutSubviews() {
        super.layoutSubviews()

        updateUI()
    }

    func setItems(titles: [String], selected: Int? = 0) {
        stackView.clear()
        bag = DisposeBag()
        selection.value = selected

        tiles = titles.enumerated().map { index, title in
            let tile = TabTileView.load(from: R.nib.tabTileView())
            tile.title = title
            tile.selected = index == selected
            stackView.add(tile)

            tile.tap.subscribe(onNext: { [weak self] in
                self?.setSelected(at: index)
            }) >>> bag

            return tile
        }

        stackView.layoutSubviews()
        updateUI()
    }

    private func setSelected(at index: Int?) {
        if let current = selection.value, let tile = tiles[safe: current] {
            tile.selected = false
        }

        selection.value = index
        guard let index = index else { return }
        guard let tile = tiles[safe: index] else { return }

        tile.selected = true
        let tileFrame = convert(tile.bounds, from: tile).insetBy(dx: -10, dy: 0).intersection(indicatorView.frame)
        scrollRectToVisible(tileFrame, animated: true)

        updateUI()
    }

    private func updateUI() {
        self.contentInset = UIEdgeInsets(top: 0, left: marginLeft, bottom: 0, right: marginRight)
        
        guard let current = selection.value, let tile = tiles[safe: current] else {
            indicator.isHidden = true
            return
        }

        let x = tile.center.x
        let position = CGPoint(x: x, y: indicatorView.bounds.height)

        indicator.isHidden = false
        indicator.position = position
    }
}

extension Reactive where Base: TabSelectionView {
    var itemSelected: ControlEvent<Int> {
        return ControlEvent<Int>(events: base.selection.asObservable().unwrap())
    }
}

fileprivate extension CAShapeLayer {
    static func indicator() -> CAShapeLayer {
        let indicator = CAShapeLayer()
        indicator.path = UIBezierPath(rect: CGRect.zero.insetBy(dx: -5, dy: -5)).cgPath
        indicator.fillColor = UIColor.white.cgColor
        indicator.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat.pi / 4))
        return indicator
    }
}
