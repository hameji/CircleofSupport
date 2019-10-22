//
//  MapViewPresenter.swift
//  CircleofSupport
//
//  Created by Hajime Taniguchi on 2019/10/17.
//  Copyright © 2019 Hajime Taniguchi. All rights reserved.
//

import UIKit

class MapViewPresenter {

    // MARK: - vars & lets
    weak var mapView: MapViewDelegate?

    // MARK: - Program Lifecycle
    func viewDidLoad() {
    }

    func postButtonPressed() {
        self.mapView?.performPostSegue()
    }

}
