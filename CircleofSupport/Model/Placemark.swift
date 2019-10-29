//
//  Placemark.swift
//  CircleofSupport
//
//  Created by Hajime Taniguchi on 2019/10/29.
//  Copyright © 2019 Hajime Taniguchi. All rights reserved.
//

import MapKit

struct Placemark {
    let location: CLLocation?
    let name: String?
    let isoCountryCode: String?
    let country: String?
    let postalCode: String?
    let administrativeArea: String?
    let subAdministrativeArea: String?
    let locality: String?
    let subLocality: String?
    let thoroughfare: String?
    let subThoroughtfare: String?
    let region: CLRegion?
    let timeZone: TimeZone?
    let inlandWater: String?
    let ocean: String?
    let areasOfInterest: [String]?
    

    var address: String? {
        get {
            guard let prefecture = administrativeArea,
                  let city = locality,
                  let town = subLocality,
                  let houseNumber = subThoroughtfare else {
                return nil
            }
            return prefecture + city + town + houseNumber
        }
    }

}
