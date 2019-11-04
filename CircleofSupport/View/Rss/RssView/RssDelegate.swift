//
//  RssTitleDelegate.swift
//  CircleofSupport
//
//  Created by Hajime Taniguchi on 2019/11/01.
//  Copyright © 2019 Hajime Taniguchi. All rights reserved.
//

import Foundation

protocol RssDelegate : class {
    func reloadTableView()
    func enableShowHP(bool: Bool)
    func segueToWebView(indexPath: IndexPath)
    func segueToPDFView(indexPath: IndexPath)
    func startIndicator()
    func stopIndicator()
    func changeSegmentName(index: Int, name: String)
}
