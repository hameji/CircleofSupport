//
//  PostStatusPresenter.swift
//  CircleofSupport
//
//  Created by Hajime Taniguchi on 2019/10/23.
//  Copyright © 2019 Hajime Taniguchi. All rights reserved.
//

import UIKit

class PostStatusPresenter {
    
    let locationManager = LocationManager()
    private var cells:[PostStatusPresentCell] = []
    var lastPost: Date? =  nil
    var address: String? = nil
    var lightSelected: Bool = true
    var gassSelected: Bool = true
    var waterSelected: Bool = true
    
    // MARK: - vars & lets
    weak var postStatusView: PostStatusDelegate?

    func setCells() {
        self.cells = [.dateCell(PostStatusDateData(date: lastPost)),
                      .addressCell(PostStatusAddressData(address: address)),
                      .lightCell(PostStatusSelectedData(isSelected: lightSelected)),
                      .gassCell(PostStatusSelectedData(isSelected: gassSelected)),
                      .waterCell(PostStatusSelectedData(isSelected: waterSelected))]
    }
    
    func checkAddress() {
    }
    
    // MARK: - Program Lifecycle
    func viewDidLoad() {
        setCells()
    }
    
    func viewWillAppear() {
        checkGPSStatus()
    }
    
    func viewWillDisappear() {
        locationManager.stopUpdatingLocation()
    }
    
    func dismissButtonPressed() {
        self.postStatusView?.dismissView()
    }
    
    func actionButtonPressed(mode: Int) {
        switch mode {
        case 0: startGPS()
        case 1: postStatus()
        default: break
        }
    }
    
    func postStatus() {
        
    }
    
    func checkGPSStatus() {
        let status = locationManager.checkAuthorization()
        switch status {
        case .always:
            fallthrough
        case .whenInUse:
            startGPS()
        case .denied, .restricted:
            self.postStatusView?.alertGPSdisabled()
        case .notDetermined:
            locationManager.askAuthorization()
        }
    }
    
    func startGPS() {
        locationManager.startUpdatingLocation { result in
            guard case .success(let locations) = result else {
                print(" ... failed to get location")
                self.postStatusView?.alertGPSfailed()
                self.locationManager.stopUpdatingLocation()
                return
            }
            guard let location = locations.first else {
                print(" ... location is nil(invalid)")
                self.postStatusView?.alertInvalidGPS()
                self.locationManager.stopUpdatingLocation()
                return
            }
            self.locationManager.gpsToAddress(location: location) { result in
                guard case .success(let location) = result else {
                    self.postStatusView?.alertAddressConversionFailed()
                    self.locationManager.stopUpdatingLocation()
                    return
                }
                guard let cLocation = location, let cAddress = cLocation.address else {
                    self.postStatusView?.alertAddressConversionFailed()
                    self.locationManager.stopUpdatingLocation()
                    return
                }
                self.address = cAddress
                self.setCells()
                self.postStatusView?.changeToPostMode()
                self.postStatusView?.reloadCollectionView()
                self.locationManager.stopUpdatingLocation()
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
        self.postStatusView?.reloadCollectionView()
    }
}
