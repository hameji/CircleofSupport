//
//  LifelineFirestoreDao.swift
//  CircleofSupport
//
//  Created by Hajime Taniguchi on 2019/10/29.
//  Copyright © 2019 Hajime Taniguchi. All rights reserved.
//

import Foundation
import Firebase

class LifelineFirestoreDao {
    
    private let firestoreManager = FirestoreManager()
    private let lifelineRef = "Lifeline"
    
    private let keyLifelineID = "LifelineID"
    private let keyPlace = "Place"
    private let keyLatitude = "Latitude"
    private let keyLongitude = "Longitude"
    private let keyPrefecture = "Prefecture"
    private let keyCity = "City"
    private let keyLight = "Light"
    private let keyGass = "Gass"
    private let keyWater = "Water"
    private let keyRegisterDate = "RegisterDate"
    private let keyRegisterUsr = "RegisterUsr"
    private let keyVerified = "Verified"
    
    // MARK: -- Functions
    func fetch(withlastDLDate lastDLDate: Date, limit: Int, completion: @escaping (Result<[Lifeline], Error>) -> ()) {
        firestoreManager.getNewData(collectionName: lifelineRef, date: lastDLDate, limit: limit) { result in
            guard case .success(let documents) = result else {
                completion(.failure(result as! Error))
                return
            }
            let lifelines = documents.map {
                Lifeline(lifelineID: $0.documentID,
                         prefecture: $0.data[self.keyPrefecture] as! String,
                         city: $0.data[self.keyCity] as! String,
                         latitude: $0.data[self.keyLatitude] as! Double,
                         longitude: $0.data[self.keyLongitude] as! Double,
                         light: $0.data[self.keyLight] as! Bool,
                         gass: $0.data[self.keyGass] as! Bool,
                         water: $0.data[self.keyWater] as! Bool,
                         registerDate: ($0.data[self.keyRegisterDate] as! Timestamp).dateValue(),
                         registerUsr: $0.data[self.keyRegisterUsr] as! String,
                         verified: $0.data[self.keyVerified] as! Bool)
            }
            completion(.success(lifelines))
            return
        }
    }

    func store(_ uid: String, placemark: Placemark, place: String, light: Bool, gass: Bool, water: Bool, completion: @escaping (Result<(), Error>) -> ()) {
        var lifelineJson: [String: Any] = [:]
        
        lifelineJson[self.keyPlace] = place
        lifelineJson[self.keyLatitude] = placemark.location?.coordinate.latitude
        lifelineJson[self.keyLongitude] = placemark.location?.coordinate.longitude
        lifelineJson[self.keyPrefecture] = placemark.administrativeArea
        lifelineJson[self.keyCity] = placemark.locality
        lifelineJson[self.keyLight] = light
        lifelineJson[self.keyGass] = gass
        lifelineJson[self.keyWater] = water
        lifelineJson[self.keyRegisterDate] = placemark.location?.timestamp
        lifelineJson[self.keyRegisterUsr] = uid
        lifelineJson[self.keyVerified] = false
        
        firestoreManager.addData(collectionName: lifelineRef, data: lifelineJson) { result in
            guard case .success( _) = result else {
                print(" ... failed to save data")
                completion(.failure(result as! Error))
                return
            }
            print(" ... suceeded saving data")
            completion(.success(()))
        }
    }
    
}
