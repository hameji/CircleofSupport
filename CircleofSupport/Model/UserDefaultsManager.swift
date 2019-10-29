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
    
    
    func getLastUpdate() -> Date {
        let date = Date(timeIntervalSince1970: ud.double(forKey: keyLastUpdate))
        return date
    }
    
    func getInstallDay() -> Date {
        let date = Date(timeIntervalSince1970: ud.double(forKey: keyInstallDay))
        return date
    }
    
    // MARK: -- set
    func set(mapDistance: Double) {
        ud.set(mapDistance, forKey: keyMapDistance)
    }
    
    func set(lastUpdate: Date) {
        let date_d = lastUpdate.timeIntervalSince1970
        ud.set(date_d, forKey: keyLastUpdate)
    }

    func set(installDay: Date) {
        let date_d = installDay.timeIntervalSince1970
        ud.set(date_d, forKey: keyInstallDay)
    }

}
