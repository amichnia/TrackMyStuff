//
// Copyright (c) 2017 GirAppe Studio. All rights reserved.
//

import Foundation
import UIKit.UIColor
import RxSwift
import BTracker

protocol AddItemViewModelType: class {
    var canAdd: Variable<Bool> { get }
    var iconsCount: Variable<Int> { get }
    var name: Variable<String?> { get }
    var page: Variable<PageProgress> { get }
    var theme: Variable<BasicViewTheme> { get }
    var beaconViewModel: BeaconViewModelType { get }

    func setup(cell: AddItemCollectionViewCellType, at indexPath: IndexPath)

    func save(sender view: SourceViewType)
    func assignBeacon(sender view: SourceViewType)
    func cancel(sender view: SourceViewType)
}

class AddItemViewModel<I: BaseItem>: AddItemViewModelType {
    var canAdd = Variable<Bool>(false)
    var iconsCount = Variable<Int>(0)
    var name = Variable<String?>(nil)
    var page = Variable<PageProgress>(PageProgress.zero)
    var beaconViewModel: BeaconViewModelType

    var theme = Variable<BasicViewTheme>(.default)

    fileprivate let bag = DisposeBag()
    fileprivate var icons: Variable<[ItemIcon]>
    fileprivate var workflow: MainWorkflowType

    init(workflow: MainWorkflowType, beacon: BeaconViewModelType, icons: [ItemIcon], storage: ItemsStorageType) {
        self.icons = Variable<[ItemIcon]>(icons)
        self.workflow = workflow
        self.beaconViewModel = beacon

        setupBindings()
    }

    func setupBindings() {
        name.asObservable().map({ $0 != nil }) --> canAdd >>> bag

        page.asObservable().map { page -> BasicViewTheme in
            return BasicViewTheme(backgrounds: self.backgroundColor(for: page), foregrounds: self.color(for: page))
        } --> theme >>> bag

        icons.asObservable().map({ $0.count }) --> iconsCount >>> bag
    }

    func setup(cell: AddItemCollectionViewCellType, at indexPath: IndexPath) {
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

    func save(sender view: SourceViewType) {
        // TODO: Save car
        workflow.addCarWorkflow.dismiss(view: view)
    }

    func assignBeacon(sender view: SourceViewType) {
        workflow.addCarWorkflow.assignBeacon(with: beaconViewModel.beacon.value, theme: theme.value, sender: view).subscribe(onNext: { beacon in
            self.beaconViewModel.beacon.value = beacon
        }, onCompleted: {
            self.beaconViewModel.isAssigned.value = self.beaconViewModel.beacon.value != nil
        }) >>> bag
    }

    func cancel(sender view: SourceViewType) {
        workflow.addCarWorkflow.dismiss(view: view)
    }
}
