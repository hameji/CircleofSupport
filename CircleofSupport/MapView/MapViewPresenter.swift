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
    private let userDefaultsManager = UserDefaultsManager()
    private let lifelineFirestoreDao = LifelineFirestoreDao()

    let locationManager = LocationManager()
    weak var mapView: MapViewDelegate?

    // MARK: - initializer
    func initializer() {
        initUserDefaults()
        downloadData()
        setTitle()
    }
    
    func initUserDefaults() {
        if userDefaultsManager.getInstallDay() == Date(timeIntervalSince1970: 0.0) {
            userDefaultsManager.set(installDay: Date())
            userDefaultsManager.set(mapDelta: 0.02)
            userDefaultsManager.set(titleType: 0)
        }
    }
    
    func downloadData() {
        let date = Date(timeIntervalSince1970: 0.0)  // userDefaultsManager.getLastUpdate()
        lifelineFirestoreDao.fetch(withlastDLDate: date, limit: 10) { result in
            guard case .success(let data) = result else {
                return
            }
            self.mapView?.setAnnotations(data: data)
        }
    }

    // MARK: - Program Lifecycle
    func viewDidLoad() {
        initializer()
    }
    
    func viewWillAppear() {
        checkGPSStatus()
    }
    
    func viewWillDisappear() {
        locationManager.stopUpdatingLocation()
    }

    // MARK: - Navigation Func
    func setTitle() {
        var date = ""
        let today = Date()
        let dateformat = DateFormatter()
        let calendar = Calendar(identifier: .gregorian)
        let titleType = userDefaultsManager.getTitleType()
        switch titleType {
        case 0: // 日
            dateformat.dateFormat = "yyyy年MM月dd日"
            date = dateformat.string(from: today)
        case 1: // 週
            dateformat.dateFormat = "yyyy年MM月dd日"
            let lastWeek = calendar.date(byAdding: .day, value: -7, to: calendar.startOfDay(for: today))!
            date = dateformat.string(from: lastWeek) + "~" + dateformat.string(from: today)
        case 2: // 月
            dateformat.dateFormat = "yyyy年MM月"
            date = dateformat.string(from: today)
        case 3: // 年
            dateformat.dateFormat = "yyyy年"
            date = dateformat.string(from: today)
        default: break
        }
        self.mapView?.setNavigationInfo(date: date)
    }

    func postButtonPressed() {
        self.mapView?.performPostSegue()
    }

    // MARK: - LocationManager Func
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
                let mapDelta = self.userDefaultsManager.getMapDelta()
                self.mapView?.setMapCenter(placemark: cPlacemark, delta: mapDelta)
                self.mapView?.setAddressCoordinate(placemark: cPlacemark)
            }
        }
    }

}
