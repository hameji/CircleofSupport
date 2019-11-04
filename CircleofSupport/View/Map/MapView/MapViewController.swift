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

    @IBOutlet weak var navigationDate: UILabel!
    @IBOutlet weak var navigationPlace: UILabel!
    @IBOutlet weak var postButton: UIBarButtonItem!
    @IBOutlet weak var categorySegment: UISegmentedControl!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var latitude: UILabel!
    @IBOutlet weak var longitude: UILabel!
    @IBOutlet weak var dummyTextField: UITextField!
    var pickerView: UIPickerView = UIPickerView()
    
    var postRange =  MKCircle(center: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0), radius: 10)
    private let mapViewPresenter = MapViewPresenter()
    
    private static let segueRoadView = "toRoadView"
    private static let segueLifelineView = "toLifelineView"
    private static let segueDamageView = "toDamageView"
    private static let segueGiveReceiveView = "toGiveReceiveView"

    // MARK: - Program Lifecycle
    func initialize() {
        setMapView()
        setTextField()
    }
    
    func setMapView() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
        self.mapView.addGestureRecognizer(longPress)
    }
    
    @objc func longPressed(sender: UILongPressGestureRecognizer) {
        guard let userMapLocation = mapView.userLocation.location else {
            return
        }

        if sender.state == .began {
            let circle = CLLocationDistance(1000)  // todo: 距離設定合わせる
            postRange = MKCircle(center: userMapLocation.coordinate, radius: circle)
            self.mapView.addOverlay(postRange)
        }
        
        print("longtapped")
        guard sender.state == .ended else { return }
        self.mapView.removeOverlay(postRange)
        let tappedPoint = sender.location(in: view)
        let tappedCoordinate = mapView.convert(tappedPoint, toCoordinateFrom: mapView)
        let tappedLocation = CLLocation(latitude: tappedCoordinate.latitude, longitude: tappedCoordinate.longitude)
        let distance = userMapLocation.distance(from: tappedLocation)
        print(distance)
        
        guard distance < 1000 else {  // todo: 距離設定
            return
        }
        var title = ""
        switch self.categorySegment.selectedSegmentIndex {
        case 0: title = "この地点の\n道路情報を投稿しますか？"
        case 1: title = "この地点の\nライフライン情報を投稿しますか？"
        case 2: title = "この地点の\n被災情報を投稿しますか？"
        case 3: title = "この地点の\n支援情報を投稿しますか？"
        default: break
        }
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let noAction = UIAlertAction(title: "いいえ", style: .cancel, handler: nil)
        let yesAction = UIAlertAction(title: "はい", style: .default, handler: { (action: UIAlertAction!) -> Void in
            switch self.categorySegment.selectedSegmentIndex {
            case 0:
                self.performSegue(withIdentifier: MapViewController.segueRoadView, sender: nil)
            case 1:
                self.performSegue(withIdentifier: MapViewController.segueLifelineView, sender: nil)
            case 2:
                self.performSegue(withIdentifier: MapViewController.segueDamageView, sender: nil)
            case 3:
                self.performSegue(withIdentifier: MapViewController.segueGiveReceiveView, sender: nil)
            default: break
            }
        })
        alert.addAction(noAction)
        alert.addAction(yesAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func setTextField() {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 44))
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonPressed))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed))
        toolbar.setItems([cancelButton, spacer, doneButton], animated: false)
        self.dummyTextField.inputAccessoryView = toolbar
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.dummyTextField.inputView = pickerView
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initialize()
        self.mapViewPresenter.mapView = self
        self.mapViewPresenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.mapViewPresenter.viewWillAppear()
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.mapViewPresenter.viewWillDisappear()
    }
    
    // MARK: - TextField setup
    
    @objc func cancelButtonPressed() {
        self.mapViewPresenter.cancelButtonPressed()
    }

    @objc func doneButtonPressed() {
        let prefectureRow = self.pickerView.selectedRow(inComponent: 1)
        self.mapViewPresenter.doneButtonPressed(prefectureRow: prefectureRow)
    }

    // MARK: - IBOutelet functions
    @IBAction func searchButtonPressed(_ sender: UIBarButtonItem) {
        self.mapViewPresenter.searchButtonPressed()

        inputOn(bool: false)
        self.dummyTextField.becomeFirstResponder()
        self.mapViewPresenter.searchButtonPressed()
    }
    
    @IBAction func postButtonPressed(_ sender: UIBarButtonItem) {
        self.mapViewPresenter.postButtonPressed(segment: self.categorySegment.selectedSegmentIndex)
    }
    
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        self.mapViewPresenter.segmentChanged(to: sender.selectedSegmentIndex)
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
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let circle = MKCircleRenderer(overlay: overlay)
        circle.strokeColor = UIColor.red
        circle.fillColor = UIColor(red: 0.5, green: 0.0, blue: 0.0, alpha: 0.5)
        circle.lineWidth = 1.0
        return circle
    }    
}

extension MapViewController: MapViewDelegate {
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

    func setNavigationInfo(date: String, place: String) {
        self.navigationDate.text = date
        self.navigationPlace.text = place
    }
    
    func reloadPickerAddressComponent() {
        self.pickerView.reloadComponent(1)
        self.pickerView.selectRow(0, inComponent: 1, animated: false)
        self.dummyTextField.reloadInputViews()
    }
    
    func resignDummyTextField() {
        self.dummyTextField.resignFirstResponder()
    }
    
    func inputOn(bool: Bool) {
        self.postButton.isEnabled = bool
        self.categorySegment.isUserInteractionEnabled = bool
        self.mapView.isUserInteractionEnabled = bool
    }
    
    func respondDummyTextField() {
        self.dummyTextField.becomeFirstResponder()
    }

}

// MARK: - UIPicker functions
extension MapViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        mapViewPresenter.pickerViewdidSelectRow(row: row, component: component)
    }
}

extension MapViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return mapViewPresenter.pickerViewnumberOfComponents()
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return mapViewPresenter.pickerViewnumberOfRowsInComponent(component: component)
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return mapViewPresenter.pickerViewtitleForRow(component: component, row: row)
    }
    
    func performRoadSegue() {
        self.performSegue(withIdentifier: MapViewController.segueRoadView, sender: nil)
    }
    
    func performLifelineSegue() {
        self.performSegue(withIdentifier: MapViewController.segueLifelineView, sender: nil)
    }
    
    func performDamageSegue() {
        self.performSegue(withIdentifier: MapViewController.segueDamageView, sender: nil)
    }
    
    func performGiveReceiveSegue() {
        self.performSegue(withIdentifier: MapViewController.segueGiveReceiveView, sender: nil)
    }
}
