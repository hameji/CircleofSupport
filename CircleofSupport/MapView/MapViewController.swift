//
//  MapViewController.swift
//  CircleofSupport
//
//  Created by Hajime Taniguchi on 2019/10/17.
//  Copyright © 2019 Hajime Taniguchi. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var navigationInfoView: UIView!
    @IBOutlet weak var navigationDate: UILabel!
    @IBOutlet weak var navigationPlace: UILabel!
    @IBOutlet weak var categorySegment: UISegmentedControl!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var latitude: UILabel!
    @IBOutlet weak var longitude: UILabel!
    private let mapViewPresenter = MapViewPresenter()
    
    private static let seguePostStatus = "postStatus"
    
    // MARK: - Program Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.mapViewPresenter.mapView = self
        self.mapViewPresenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.mapViewPresenter.viewWillAppear()
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.mapViewPresenter.viewWillDisappear()
    }

    @IBAction func postButtonPressed(_ sender: UIBarButtonItem) {
        self.mapViewPresenter.postButtonPressed()
    }
    
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
    }
    
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }

        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        annotationView = makeNewMKPointView(id: identifier, annotation: annotation)
        return annotationView
    }
    
    func makeNewMKPointView(id: String, annotation: MKAnnotation) -> MKAnnotationView {
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: id)
        annotationView.canShowCallout = true
        let customAnnotation = annotationView.annotation as! CustomAnnotation
        if let data = customAnnotation.data {
            if data.light, data.gass, data.water {
                annotationView.pinTintColor = UIColor.green
            } else if !data.light, !data.gass, !data.water {
                annotationView.pinTintColor = UIColor.red
            } else if !data.light || !data.gass || !data.water {
                annotationView.pinTintColor = UIColor.yellow
            }
        }
        return annotationView
    }
}

extension MapViewController: MapViewDelegate {
    func performPostSegue() {
        self.performSegue(withIdentifier: MapViewController.seguePostStatus, sender: nil)
    }

    func setAddressCoordinate(placemark: Placemark) {
        self.address.text = placemark.address
        self.latitude.text = String(format: "%.7f", placemark.location!.coordinate.latitude)
        self.longitude.text = String(format: "%.7f", placemark.location!.coordinate.longitude)
    }
    
    func setMapCenter(placemark: Placemark, delta: Double) {
        self.mapView.showsUserLocation = true
        var region:MKCoordinateRegion = mapView.region
        region.center = CLLocationCoordinate2D(latitude: placemark.location!.coordinate.latitude,
        longitude: placemark.location!.coordinate.longitude)
        region.span.latitudeDelta = delta
        region.span.longitudeDelta = delta
        self.mapView.setRegion(region,animated:true)
    }
    
    func setAnnotations(data: [Lifeline]) {
        let df = DateFormatter()
        df.dateFormat = "yyyy年MM月dd日 HH:mm"
        df.locale = Locale(identifier: "en_US_POSIX")
        let annotations: [CustomAnnotation] = data.map {
            let annotation = CustomAnnotation()
            annotation.title = df.string(from: $0.registerDate)
            annotation.data = $0
            annotation.subtitle = $0.totalStatus
            annotation.coordinate = $0.coordinate
            return annotation
        }
        self.mapView.addAnnotations(annotations)
    }

    func setTitle(title: String) {
        self.tabBarItem.title = title
    }

}
