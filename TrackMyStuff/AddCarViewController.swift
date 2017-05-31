//
// Copyright (c) 2017 GirAppe Studio. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AddCarViewController: UIViewController {
    @IBOutlet weak var collectionView: PagedCollectionView!

    // TODO: Setup DI
    let bag = DisposeBag()
    var icons: [ItemIcon] = Car.icons

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBindings()
    }

    private func setupBindings() {
        collectionView.rx.pageProgress.subscribe(onNext: { page in
            let colorA = self.icons[page.current].color
            let colorB = self.icons[page.next].color
            self.view.backgroundColor = UIColor.interpolate(colorA: colorA, colorB: colorB, factor: page.progress)
        }) >>> bag
    }
}

extension AddCarViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return icons.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.addCarCollectionViewCell, for: indexPath) else {
            return UICollectionViewCell()
        }

        cell.image = icons[indexPath.row].image
        return cell
    }
}
