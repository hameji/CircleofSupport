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
    private let keyMapDelta = "mapDelta"
    private let keyTitleType = "titleType"

    // MARK: -- get
    func getTitleType() -> Int {
        return ud.integer(forKey: keyTitleType)
    }

    func getMapDelta() -> Double {
        return ud.double(forKey: keyMapDelta)
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
    func set(titleType: Int) {
        ud.set(titleType, forKey: keyTitleType)
    }

    func set(mapDelta: Double) {
        ud.set(mapDelta, forKey: keyMapDelta)
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
