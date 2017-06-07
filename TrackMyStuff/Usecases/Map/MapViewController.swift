//
// Copyright (c) 2017 GirAppe Studio. All rights reserved.
//

import UIKit
import MapKit
import RxSwift
import RxCocoa

class MapViewController: BaseViewController {
    @IBOutlet weak var mapView: MKMapView!

    var viewModel: MapViewModelType!
    var annotation: MKAnnotation?
    var zoommed = false
    var annotationBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBindings()
    }

    func setupBindings() {
        viewModel.annotation.asObservable().observeOnMain().subscribe(onNext: { (model: MapAnnotationViewModelType?) in
            self.mapView.removeAnnotations(self.annotation.toArray)
            self.annotation = nil
            self.zoommed = false
            guard let model = model else { return }
            self.setupBindings(for: model)
        }) >>> bag
    }

    func setupBindings(for model: MapAnnotationViewModelType) {
        annotationBag = DisposeBag()

        model.coordinate.asObservable().observeOnMain().subscribe(onNext: { coordinate in
            self.mapView.removeAnnotations(self.annotation.toArray)

            guard let coordinate = coordinate else { return }

            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = model.title
            self.mapView.addAnnotation(annotation)
            self.annotation = annotation

            guard !self.zoommed else { return }
            self.mapView.showAnnotations([annotation], animated: true)
            self.zoommed = true
        }) >>> annotationBag
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }

        return nil
    }
}
