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

extension MapViewController: MapViewDelegate {
    func performPostSegue() {
        self.performSegue(withIdentifier: MapViewController.seguePostStatus, sender: nil)
    }

    func setAddressCoordinate(placemark: Placemark) {
        self.address.text = placemark.address
        self.latitude.text = String(format: "%.7f", placemark.location!.coordinate.latitude)
        self.longitude.text = String(format: "%.7f", placemark.location!.coordinate.longitude)
    }
}
