//
//  TabTileView.swift
//  NedBankApp
//
//  Created by Andrzej Michnia on 04.08.2017.
//  Copyright © 2017 NedBank. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol TabTileViewType: class {
    var title: String? { get set }
    var selected: Bool { get set }
    var tap: Observable<Void> { get }
}

class TabTileView: UIView {
    @IBOutlet weak var titleLabel: UILabel!

    let tapRecognizer = UITapGestureRecognizer()
    var selected: Bool = false {
        didSet {
            let size = titleLabel.font.pointSize
            if selected {
                titleLabel.alpha = 1.0
                titleLabel.font = UIFont.boldSystemFont(ofSize: size)
            } else {
                titleLabel.alpha = 0.4
                titleLabel.font = UIFont.systemFont(ofSize: size)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        addGestureRecognizer(tapRecognizer)
    }
}

extension TabTileView: TabTileViewType {
    var title: String? {
        get { return titleLabel.text }
        set { titleLabel.text = newValue }
    }
    var tap: Observable<Void> {
        return tapRecognizer.rx.event.map({ _ -> Void in })
    }
}
