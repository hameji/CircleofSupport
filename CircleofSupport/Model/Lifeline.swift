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
}
