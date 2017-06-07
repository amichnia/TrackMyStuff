//
// Copyright (c) 2017 GirAppe Studio. All rights reserved.
//

import UIKit
import MapKit
import RxSwift
import RxCocoa
import BTracker
import CoreLocation

protocol MapAnnotationViewModelType: class {
    var coordinate: Variable<CLLocationCoordinate2D?> { get }
    var title: String { get }
    var image: UIImage { get }
    var color: UIColor { get }
}

class MapAnnotationViewModel: MapAnnotationViewModelType {
    var coordinate: Variable<CLLocationCoordinate2D?>
    var title: String
    var image: UIImage
    var color: UIColor

    let bag = DisposeBag()

    init?(item: ItemType) {
        self.coordinate = Variable<CLLocationCoordinate2D?>(item.location.value?.coordinate)
        self.title = item.name
        self.image = item.icon.image
        self.color = item.icon.color

        setupBindings(with: item)
    }

    func setupBindings(with item: ItemType) {
        item.location.asObservable().map({ $0?.coordinate }) --> coordinate >>> bag
    }
}

protocol MapViewModelType: class {
    var annotation: Variable<MapAnnotationViewModelType?> { get }
}

class MapViewModel: MapViewModelType {
    var annotation = Variable<MapAnnotationViewModelType?>(nil)

    let bag = DisposeBag()
    var currentBag = DisposeBag()
    let workflow: MainWorkflowType
    let storage: ItemsStorageType

    init(workflow: MainWorkflowType, storage: ItemsStorageType) {
        self.workflow = workflow
        self.storage = storage

        setupBindings()
    }

    func setupBindings() {
        workflow.selectedItem.asObservable().map { (item: ItemType?) -> MapAnnotationViewModelType? in
            guard let item = item else  { return nil }
            return MapAnnotationViewModel(item: item)
        }.bind(to: annotation) >>> bag
    }
}

fileprivate extension Location {
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
