//
// Copyright (c) 2017 GirAppe Studio. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

struct PageProgress {
    let previous: Int
    let next: Int
    let progress: Double
}

extension PageProgress {
    static let zero = PageProgress(previous: 0, next: 0, progress: 0)

    var current: Int {
        return progress >= 0.5 ? next : previous
    }
}

enum CollectionPageError: Error {
    case wrongLayout(is: String, desired: String)
}

class PagedCollectionView: UICollectionView {
    override func layoutSubviews() {
        setupLayout()

        super.layoutSubviews()
    }

    func setupLayout() {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }

        var size = bounds.size
        size.width -= contentInset.left
        size.width -= contentInset.right
        size.height -= contentInset.top
        size.height -= contentInset.bottom
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = .zero
        layout.itemSize = size
    }
}

extension Reactive where Base: PagedCollectionView {
    var pageProgress: Observable<PageProgress> {
        guard let layout = base.collectionViewLayout as? UICollectionViewFlowLayout else {
            let current = String(describing: base.collectionViewLayout.self)
            let desired = String(describing: UICollectionViewFlowLayout.self)
            return Observable.error(CollectionPageError.wrongLayout(is: current, desired: desired))
        }

        let horizontal = layout.scrollDirection == .horizontal

        return base.rx.contentOffset.asObservable()
        .map { point -> (Double,Double,Double) in
            let value = horizontal ? point.x : point.y
            let bound = horizontal ? self.base.contentSize.width : self.base.contentSize.height
            let page = horizontal ? self.base.bounds.width : self.base.bounds.height
            let offset = Swift.max(0, Swift.min(value, bound))
            return (Double(offset),Double(bound),Double(page))
        }
        .map{ (offset, bound, page) -> PageProgress in
            let last = Swift.max(round(bound / page), 1.0) - 1.0
            let current = floor(offset / page)
            let next = Swift.min(ceil(offset / page), last)
            let progress = Swift.max(0, Swift.min((offset / page) - current, 1))
            return PageProgress(previous: Int(current), next: Int(next), progress: progress)
        }
    }
}
