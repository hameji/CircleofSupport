//
//  LocationManager.swift
//  CircleofSupport
//
//  Created by Hajime Taniguchi on 2019/10/29.
//  Copyright © 2019 Hajime Taniguchi. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager: NSObject {
    
    private let locationManager = CLLocationManager()
    private var completion: ((Result<[Location], Error>) -> ())? = nil

    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func checkAuthorization() -> GpsAuthorization {
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedAlways:
            return .always
        case .authorizedWhenInUse:
            return .whenInUse
        case .restricted:
            return .restricted
        case .denied:
            return .denied
        case .notDetermined:
            return .notDetermined
        @unknown default:
            print(" ... unexpected locationAuthorization status.")
            return .denied
        }
    }
    
    func askAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }

    func startUpdatingLocation(_ completion: @escaping (Result<[Location], Error>) -> ()) {
        self.completion = completion
        print(" ... started updating location.")
        locationManager.startUpdatingLocation()
    }

    func stopUpdatingLocation() {
        print(" ... stopped updating location.")
        locationManager.stopUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let slocations = locations.map {
            Location(latitude: $0.coordinate.latitude,
                     longitude: $0.coordinate.longitude,
                     altitude: $0.altitude,
                     horizontalAccuracy: $0.horizontalAccuracy,
                     verticalAccuracy: $0.verticalAccuracy,
                     timestamp: $0.timestamp,
                     speed: $0.speed,
                     course: $0.course)
        }
        completion?(.success(slocations))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        completion?(.failure(error))
        
    }
    
    
}
