//
//  Lifeline.swift
//  CircleofSupport
//
//  Created by Hajime Taniguchi on 2019/10/29.
//  Copyright © 2019 Hajime Taniguchi. All rights reserved.
//

import Foundation
import MapKit

struct Lifeline {
    let lifelineID: String
    let prefecture: String
    let city: String
    let latitude: Double
    let longitude: Double
    let light: Bool
    let gass: Bool
    let water: Bool
    let registerDate: Date
    let registerUsr: String
    let verified: Bool
    
    var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            }
    }

    var lightStatus: String {
        get {
            if light {
                return "OK"
            } else {
                return "不通"
            }
        }
    }

    var gassStatus: String {
        get {
            if gass {
                return "OK"
            } else {
                return "不通"
            }
        }
    }

    var waterStatus: String {
        get {
            if water {
                return "OK"
            } else {
                return "不通"
            }
        }
    }

    var totalStatus: String {
        get {
            return "電気:" + lightStatus + ", ガス:" + gassStatus + ", 水道:" + waterStatus
        }
    }
}
