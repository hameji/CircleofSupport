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
    var addressType: AddressType = .medium
    let datePeriod = ["今日", "今週", "今月", "今年"]
    var cities: [String] = []
    var address:[String] = []
    private let userDefaultsManager = UserDefaultsManager()
    private let lifelineFirestoreDao = LifelineFirestoreDao()

    let locationManager = LocationManager()
    weak var mapView: MapViewDelegate?

    // MARK: - initializer
    func initializer() {
        initUserDefaults()
        downloadData()
        setAddressArray()
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
    
    func setAddressArray() {
        if addressType == .medium {
            cities = AddressData.akita
            address = cities
            address.append("他の都道府県")
        } else if addressType == .short {
            address = AddressData.prefecture
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
    func setNavigationInfo(prefectureCity: String?) {
        guard let breifAddress = prefectureCity else {
            return
        }
        var date = ""
        let dateformat = DateFormatter()
        let calendar = Calendar(identifier: .gregorian)
        let titleType = userDefaultsManager.getTitleType()
        switch titleType {
        case 0: // 日
            dateformat.dateFormat = "yyyy/MM/dd"
            date = dateformat.string(from: Date())
        case 1: // 週
            dateformat.dateFormat = "yyyy/MM/dd"
            let lastWeek = calendar.date(byAdding: .day, value: -7, to: calendar.startOfDay(for: Date()))!
            date = dateformat.string(from: lastWeek) + "~" + dateformat.string(from: Date())
        case 2: // 月
            dateformat.dateFormat = "yyyy/MM"
            date = dateformat.string(from: Date())
        case 3: // 年
            dateformat.dateFormat = "yyyy"
            date = dateformat.string(from: Date())
        default: break
        }
        self.mapView?.setNavigationInfo(date: date, place: breifAddress)
    }

    func postButtonPressed(segment: Int) {
        switch segment {
        case 0: self.mapView?.performRoadSegue()
        case 1: self.mapView?.performLifelineSegue()
        case 2: self.mapView?.performDamageSegue()
        case 3: self.mapView?.performGiveReceiveSegue()
        default: break
        }
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
                self.setNavigationInfo(prefectureCity: cPlacemark.breifAddress)
                self.mapView?.setAddressCoordinate(placemark: cPlacemark)
            }
        }
    }
    
    // MARK: - PickerView Func
    func pickerViewdidSelectRow(row: Int, component: Int) {
        print("addressType:", addressType, ", row:", row, ", component:", component)
        if addressType == .medium, component == 1, row == address.count - 1 {
            addressType = .short
            setAddressArray()
            self.mapView?.reloadPickerAddressComponent()
        }
    }
    
    func pickerViewnumberOfComponents() -> Int {
        return 2  // date, address
    }

    func pickerViewnumberOfRowsInComponent(component: Int) -> Int {
        if component == 0 {  // dateType
            return datePeriod.count
        } else {  // addressType
            return address.count
        }
    }
    
    func pickerViewtitleForRow(component: Int, row: Int) -> String {
        switch component {
        case 0:
            return datePeriod[row]
        case 1:
            return address[row]
        default:
            return ""
        }
    }

    // MARK: - SegmentedControl Func
    func segmentChanged(to: Int) {
        // todo: ここでデータの取得、pinを立てる
        switch to {
        case 0:
            print("1")
            break
        case 1:
            print("2")
            break
        case 2:
            print("3")
            break
        case 3:
            print("4")
            break
        default: break
        }
        
    }

    // MARK: - NavigationButton Func
    func searchButtonPressed() {
        self.mapView?.inputOn(bool: false)
        self.mapView?.respondDummyTextField()
    }

    func cancelButtonPressed() {
        self.mapView?.resignDummyTextField()
        self.mapView?.inputOn(bool: true)
    }
    
    
    func doneButtonPressed(prefectureRow: Int) {
        if addressType == .short {
            addressType = .medium
            let totalAdress = AddressData.returnAdressArray()
            address = totalAdress[prefectureRow]
            address.append("他の都道府県")
            self.mapView?.reloadPickerAddressComponent()
        } else {
            self.mapView?.resignDummyTextField()
            self.mapView?.inputOn(bool: true)
        }
    }
    
}
