//
// Copyright (c) 2017 GirAppe Studio. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import BTracker

protocol ItemsViewModelType: class {
    var view: SourceViewType! { get set }

    var numberOfSections: Variable<Int> { get }

    func numberOfRows(`in` section: Int) -> Int
    func setup(_ header: ItemHeaderCellType, at section: Int)
    func setup(_ cell: ItemCellType, at indexPath: IndexPath)

    func addNewItem(from sender: SourceViewType)
}

class ItemsViewModel {
    weak var view: SourceViewType!
    var numberOfSections = Variable<Int>(0)
    var sections = Variable<[SectionViewModelType]>([])

    let bag = DisposeBag()
    let workflow: MainWorkflowType
    let storage: ItemsStorageType

    init(workflow: MainWorkflowType, storage: ItemsStorageType) {
        self.workflow = workflow
        self.storage = storage

        setupBindings()
    }

    private func setupBindings() {
        let carsSection = storage.cars.asObservable().map({ SectionViewModel(.car, title: "CARS", items: $0) })
        let bikesSection = storage.bikes.asObservable().map({ SectionViewModel(.bike, title: "BIKES", items: $0) })
        let otherSection = storage.other.asObservable().map({ SectionViewModel(.other, title: "OTHER", items: $0) })

        let sectionsCombined = Observable.combineLatest(carsSection, bikesSection, otherSection) { (cars, bikes, other) in
            return [cars, bikes, other] as [SectionViewModelType]
        }

        sectionsCombined.bind(to: sections) >>> bag
        sections.asObservable().map({ $0.count }).bind(to: numberOfSections) >>> bag
    }
}

extension ItemsViewModel: ItemsViewModelType {
    func numberOfRows(`in` section: Int) -> Int {
        return sections.value[safe: section]?.count ?? 0
    }

    func setup(_ header: ItemHeaderCellType, at section: Int) {
        guard let section = sections.value[safe: section] else { return }
        header.title = section.title
        header.addHandler = {
            self.workflow.addItemWorkflow.start(from: self.view, with: section.itemsType)
        }
    }

    func setup(_ cell: ItemCellType, at indexPath: IndexPath) {
        sections.value[safe: indexPath.section]?.setup(cell, at: indexPath)
    }

    func addNewItem(from sender: SourceViewType) {
        workflow.addItemWorkflow.start(from: sender, with: .bike)
    }
}
