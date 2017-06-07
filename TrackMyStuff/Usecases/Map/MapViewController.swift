//
// Copyright (c) 2017 GirAppe Studio. All rights reserved.
//

import UIKit
import MapKit
import RxSwift
import RxCocoa
import SnapKit

class ItemAnnotationView: MKAnnotationView {
    func setup(with image: UIImage?, color: UIColor?) {
        backgroundColor = UIColor.white
        bounds.size = CGSize(width: 58, height: 58)
        layer.cornerRadius = 29
        layer.masksToBounds = true

        subviews.forEach { $0.removeFromSuperview() }
        let imageView = UIImageView(image: image)
        imageView.frame = bounds.insetBy(dx: 4, dy: 4)
        addSubview(imageView)
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 25
        imageView.backgroundColor = color ?? UIColor.gray
    }
}

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

        let view = mapView.dequeueReusableAnnotationView(withIdentifier: "selectedItem") ?? ItemAnnotationView(annotation: annotation, reuseIdentifier: "selectedItem")

        view.annotation = annotation
        (view as? ItemAnnotationView)?.setup(with: viewModel.annotation.value?.image, color: viewModel.annotation.value?.color)

        return view
    }
}
