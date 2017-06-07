//
// Copyright (c) 2017 GirAppe Studio. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import BTracker

protocol ItemsViewModelType: class {
    var numberOfSections: Variable<Int> { get }

    func numberOfRows(`in` section: Int) -> Int
    func title(`for` section: Int) -> String
    func setup(_ cell: ItemCellType, at indexPath: IndexPath)

    func addNewItem(from sender: SourceViewType)
}

class ItemsViewModel {
    var numberOfSections: Variable<Int>
    var sections: Variable<[SectionViewModelType]>
    var cars: Variable<[Car]>

    let bag = DisposeBag()
    var workflow: MainWorkflowType!

    init(workflow: MainWorkflowType, storage: ItemsStorageType) {
        self.workflow = workflow
        self.cars = Variable<[Car]>(storage.cars)
        let carsSection = SectionViewModel(title: R.string.localizable.itemsSectionCars(), items: storage.cars)
        sections = Variable<[SectionViewModelType]>([carsSection])
        numberOfSections = Variable<Int>(1)

        setupBindings()
    }

    private func setupBindings() {
        let carsSection = cars.asObservable().map({ SectionViewModel(title: "Cars", items: $0) })
        carsSection.map({ [$0] }).bind(to: sections) >>> bag

        sections.asObservable().map({ $0.count }).bind(to: numberOfSections) >>> bag
    }
}

extension ItemsViewModel: ItemsViewModelType {
    func numberOfRows(`in` section: Int) -> Int {
        return sections.value[safe: section]?.count ?? 0
    }

    func title(`for` section: Int) -> String {
        return sections.value[safe: section]?.title ?? ""
    }

    func setup(_ cell: ItemCellType, at indexPath: IndexPath) {
        sections.value[safe: indexPath.section]?.setup(cell, at: indexPath)
    }

    func addNewItem(from sender: SourceViewType) {
        workflow.addCarWorkflow.start(from: sender, with: .bike)
    }
}
