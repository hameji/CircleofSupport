//
//  TopViewDelegate.swift
//  CircleofSupport
//
//  Created by Hajime Taniguchi on 2019/10/17.
//  Copyright © 2019 Hajime Taniguchi. All rights reserved.
//

protocol TopViewDelegate : class {
    func segueToMain()
    func alertLoginFailed()
    func startIndicator()
    func stopIndicator()
}
