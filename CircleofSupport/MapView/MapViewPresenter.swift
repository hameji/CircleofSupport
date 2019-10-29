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
    private let authentication = Authentication()
    private let lifelineFirestoreDao = LifelineFirestoreDao()

    weak var mapView: MapViewDelegate?
    var lifelineData: [Lifeline] = []

    // MARK: - Program Lifecycle
    func viewDidLoad() {
        downloadData()
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
                guard let cPlacemark = placemark, let _ = cPlacemark.address else {
                    return
                }
                self.mapView?.setAddressCoordinate(placemark: cPlacemark)
            }
        }
    }
    
    func downloadData() {
        let date = Date().addingTimeInterval(-60*60*24*10)
        lifelineFirestoreDao.fetch(withlastDLDate: date, limit: 10) { result in
            guard case .success(let data) = result else {
                return
            }
            self.lifelineData = data
            // setAnnotations
        }
    }

}
