//
//  MapViewDelegate.swift
//  CircleofSupport
//
//  Created by Hajime Taniguchi on 2019/10/17.
//  Copyright © 2019 Hajime Taniguchi. All rights reserved.
//

protocol MapViewDelegate : class {
    func performRoadSegue()
    func performLifelineSegue()
    func performDamageSegue()
    func performGiveReceiveSegue()
    func setAddressCoordinate(placemark: Placemark)
    func setMapCenter(placemark: Placemark, delta: Double)
    func setAnnotations(data: [Lifeline])
    func setNavigationInfo(date: String, place: String)
    func reloadPickerAddressComponent()
    func respondDummyTextField()
    func resignDummyTextField()
    func inputOn(bool: Bool)
}
