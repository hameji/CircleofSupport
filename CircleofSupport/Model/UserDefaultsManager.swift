//
//  UserDefaultsManager.swift
//  CircleofSupport
//
//  Created by Hajime Taniguchi on 2019/10/30.
//  Copyright © 2019 Hajime Taniguchi. All rights reserved.
//

import Foundation

class UserDefaultsManager {
    private let ud = UserDefaults.standard

    // MARK: -- keys
    private let keyLastUpdate = "lastUpdate"
    private let keyInstallDay = "installDay"
    private let keyMapDistance = "mapDistance"

    // MARK: -- get
    func getMapDistance() -> Double {
        return ud.double(forKey: keyMapDistance)
    }
    
    
    func getLastUpdate() -> Double {
        return ud.double(forKey: keyLastUpdate)
    }
    
    func getInstallDay() -> Double {
        return ud.double(forKey: keyInstallDay)
    }
    
    // MARK: -- set
    func set(mapDistance: Double) {
        ud.set(mapDistance, forKey: keyMapDistance)
    }
    
    func set(lastUpdate: Double) {
        ud.set(lastUpdate, forKey: keyLastUpdate)
    }

    func set(installDay: Double) {
        ud.set(installDay, forKey: keyInstallDay)
    }

}
