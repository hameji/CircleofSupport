//
//  RssTitleDelegate.swift
//  CircleofSupport
//
//  Created by Hajime Taniguchi on 2019/11/01.
//  Copyright © 2019 Hajime Taniguchi. All rights reserved.
//

import Foundation

protocol RssTitleDelegate : class {
    func reloadTableView()
    func segueToDetail(indexPath: IndexPath)
}
