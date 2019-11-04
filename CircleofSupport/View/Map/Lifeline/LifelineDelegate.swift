//
//  PostStatusDelegate.swift
//  CircleofSupport
//
//  Created by Hajime Taniguchi on 2019/10/23.
//  Copyright © 2019 Hajime Taniguchi. All rights reserved.
//

protocol LifelineDelegate : class {
    func reloadCollectionView()
    func dismissView()
    func alertGPSdisabled()
    func alertGPSfailed()
    func alertInvalidGPS()
    func alertUnLoggedIn()
    func alertUpdateFailed()
    func alertAddressConversionFailed()
    func changeToPostMode()
}
