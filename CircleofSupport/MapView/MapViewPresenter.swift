//
//  MapViewPresenter.swift
//  CircleofSupport
//
//  Created by Hajime Taniguchi on 2019/10/17.
//  Copyright © 2019 Hajime Taniguchi. All rights reserved.
//

import UIKit

class MapViewPresenter {
    
    // MARK: - vars & lets
    let locationManager = LocationManager()
    weak var mapView: MapViewDelegate?

    // MARK: - Program Lifecycle
    func viewDidLoad() {
    }
    
    func viewWillAppear() {
        checkGPSStatus()
    }
    
    func viewWillDisappear() {
        locationManager.stopUpdatingLocation()
    }

    func postButtonPressed() {
        self.mapView?.performPostSegue()
    }

    func checkGPSStatus() {
        let status = locationManager.checkAuthorization()
        switch status {
        case .always:
            fallthrough
        case .whenInUse:
            startGPS()
        case .denied, .restricted:
            break
        case .notDetermined:
            locationManager.askAuthorization()
        }
    }
    
    func startGPS() {
        locationManager.startUpdatingLocation { result in
            self.locationManager.stopUpdatingLocation()
            guard case .success(let locations) = result else {
                print(" ... failed to get location")
                return
            }
            guard let location = locations.first else {
                print(" ... location is nil(invalid)")
                return
            }
            self.locationManager.gpsToAddress(location: location) { result in
                guard case .success(let placemark) = result else {
                    return
                }
                guard let cPlacemark = placemark, let cAddress = cPlacemark.address else {
                    return
                }
                self.mapView?.setAddressCoordinate(placemark: cPlacemark)
            }
        }
    }

}
