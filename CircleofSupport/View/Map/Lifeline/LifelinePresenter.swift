//
//  PostStatusPresenter.swift
//  CircleofSupport
//
//  Created by Hajime Taniguchi on 2019/10/23.
//  Copyright © 2019 Hajime Taniguchi. All rights reserved.
//

import UIKit

class LifelinePresenter {
    
    let locationManager = LocationManager()
    private let authentication = Authentication()
    private let lifelineFirestoreDao = LifelineFirestoreDao()
    private let userDefaultsManager = UserDefaultsManager()
    
    private var cells:[PostStatusPresentCell] = []
    var placemark: Placemark? = nil
    var place: String = "自宅"
    var lastPost: Date? =  nil
    var address: String? = nil
    var lightSelected: Bool = true
    var gassSelected: Bool = true
    var waterSelected: Bool = true
    
    // MARK: - vars & lets
    weak var lifelineView: LifelineDelegate?

    func setCells() {
        self.cells = [.dateCell(PostStatusDateData(date: lastPost)),
                      .addressCell(PostStatusAddressData(address: address)),
                      .lightCell(PostStatusSelectedData(isSelected: lightSelected)),
                      .gassCell(PostStatusSelectedData(isSelected: gassSelected)),
                      .waterCell(PostStatusSelectedData(isSelected: waterSelected))]
    }
    
    // MARK: - Program Lifecycle
    func viewDidLoad() {
        setCells()
        if userDefaultsManager.getLastUpdate() != Date(timeIntervalSince1970: 0.0) {
            lastPost = userDefaultsManager.getLastUpdate()
        }
    }
    
    func viewWillAppear() {
        checkGPSStatus()
    }
    
    func viewWillDisappear() {
        locationManager.stopUpdatingLocation()
    }
    
    func dismissButtonPressed() {
        self.lifelineView?.dismissView()
    }
    
    func actionButtonPressed(mode: Int) {
        switch mode {
        case 0: startGPS()
        case 1: postStatus()
        default: break
        }
    }
    
    func postStatus() {
        guard let user = authentication.getCurrentUser() else {
            self.lifelineView?.alertUnLoggedIn()
            return
        }
        guard let cPlacemark = placemark else {
            self.lifelineView?.alertAddressConversionFailed()
            return
        }
        lifelineFirestoreDao.store(user.uid, placemark: cPlacemark, place: place, light: lightSelected, gass: gassSelected, water: waterSelected) { result in
            guard case .success( _) = result else {
                self.lifelineView?.alertUpdateFailed()
                return
            }
            self.userDefaultsManager.set(lastUpdate: cPlacemark.location!.timestamp)
            self.lifelineView?.dismissView()
        }
    }
    
    func checkGPSStatus() {
        let status = locationManager.checkAuthorization()
        switch status {
        case .always:
            fallthrough
        case .whenInUse:
            startGPS()
        case .denied, .restricted:
            self.lifelineView?.alertGPSdisabled()
        case .notDetermined:
            locationManager.askAuthorization()
        }
    }
    
    func startGPS() {
        locationManager.startUpdatingLocation { result in
            self.locationManager.stopUpdatingLocation()
            guard case .success(let locations) = result else {
                print(" ... failed to get location")
                self.lifelineView?.alertGPSfailed()
                return
            }
            guard let location = locations.first else {
                print(" ... location is nil(invalid)")
                self.lifelineView?.alertInvalidGPS()
                return
            }
            self.locationManager.gpsToAddress(location: location) { result in
                guard case .success(let placemark) = result else {
                    self.lifelineView?.alertAddressConversionFailed()
                    return
                }
                guard let cPlacemark = placemark, let cAddress = cPlacemark.address else {
                    self.lifelineView?.alertAddressConversionFailed()
                    return
                }
                self.placemark = cPlacemark
                self.address = cAddress
                self.setCells()
                self.lifelineView?.changeToPostMode()
                self.lifelineView?.reloadCollectionView()
            }
        }
    }
    
    // MARK: - UICollectionView DelegateFlowLayout
    func sizeForItemAt(viewWidth: CGFloat, indexPath: IndexPath) -> CGSize {
        var eachHeight: Int = 0
        let celltype = cellForItemAt(indexPath: indexPath)
        switch celltype {
        case .dateCell:
            eachHeight = 40
        case .addressCell( _):
            eachHeight = 90
        default:
            eachHeight = 260
        }
        return CGSize(width: viewWidth, height: CGFloat(eachHeight))
    }

    func numberOfItemsInSection() -> Int {
        return self.cells.count
    }

    func cellForItemAt(indexPath: IndexPath) -> PostStatusPresentCell {
        return self.cells[indexPath.row]
    }
    
    func didSelectItemAt(indexPath: IndexPath) {
        switch indexPath.row {
        case 2:
            if lightSelected {
                lightSelected = false
            } else {
                lightSelected = true
            }
        case 3:
            if gassSelected {
                gassSelected = false
            } else {
                gassSelected = true
            }
        case 4:
            if waterSelected {
                waterSelected = false
            } else {
                waterSelected = true
            }
        default: break
        }
        setCells()
        self.lifelineView?.reloadCollectionView()
    }
    
    func segmentChanged(index: Int) {
        switch index {
        case 0: place = "自宅"
        case 1: place = "職場"
        case 2: place = "その他"
        default: break
        }
    }
}
