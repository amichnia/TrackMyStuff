//
// Copyright (c) 2017 GirAppe Studio. All rights reserved.
//

import Foundation
import UIKit.UIColor
import RxSwift

protocol AddCarViewModelType: class {
    var canAdd: Variable<Bool> { get }
    var iconsCount: Variable<Int> { get }
    var name: Variable<String?> { get }
    var plates: Variable<String?> { get }
    var page: Variable<PageProgress> { get }
    var color: Variable<UIColor> { get }
    var backgroundColor: Variable<UIColor> { get }

    func setup(cell: AddCarCollectionViewCellType, at indexPath: IndexPath)
    func add(car: Car)
    func cancel(addingFrom view: SourceViewType)
}

class AddCarViewModel: AddCarViewModelType {
    var canAdd = Variable<Bool>(false)
    var iconsCount = Variable<Int>(0)
    var name = Variable<String?>(nil)
    var plates = Variable<String?>(nil)
    var page = Variable<PageProgress>(PageProgress.zero)
    var color = Variable<UIColor>(.black)
    var backgroundColor = Variable<UIColor>(.white)

    fileprivate let bag = DisposeBag()
    fileprivate var icons: Variable<[ItemIcon]>
    fileprivate var workflow: MainWorkflowType

    init(workflow: MainWorkflowType, icons: [ItemIcon] = Car.icons) {
        self.icons = Variable<[ItemIcon]>(icons)
        self.workflow = workflow

        setupBindings()
    }

    func setupBindings() {
        name.asObservable().map({ $0 != nil }) --> canAdd >>> bag
        page.asObservable().map({ self.color(for: $0) }) --> color >>> bag
        page.asObservable().map({ self.backgroundColor(for: $0) }) --> backgroundColor >>> bag
        icons.asObservable().map({ $0.count }) --> iconsCount >>> bag
    }

    func setup(cell: AddCarCollectionViewCellType, at indexPath: IndexPath) {
        guard let icon = icons.value[safe: indexPath.row] else { return }

        cell.image = icon.image
    }

    private func backgroundColor(for page: PageProgress) -> UIColor {
        let colorA = self.icons.value[safe: page.previous]?.color ?? UIColor.white
        let colorB = self.icons.value[safe: page.next]?.color ?? UIColor.white
        return UIColor.interpolate(colorA: colorA, colorB: colorB, factor: page.progress)
    }

    private func color(for page: PageProgress) -> UIColor {
        let colorA = self.icons.value[safe: page.previous]?.font.color ?? UIColor.black
        let colorB = self.icons.value[safe: page.next]?.font.color ?? UIColor.black
        return UIColor.interpolate(colorA: colorA, colorB: colorB, factor: page.progress)
    }

    func add(car: Car) {
        // TODO: Add cart to storage?
    }

    func cancel(addingFrom view: SourceViewType) {
        workflow.addCarWorkflow.dismiss(view: view)
    }
}
