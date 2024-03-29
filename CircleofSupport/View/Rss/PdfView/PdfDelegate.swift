//
//  RssContentDelegate.swift
//  CircleofSupport
//
//  Created by Hajime Taniguchi on 2019/11/01.
//  Copyright © 2019 Hajime Taniguchi. All rights reserved.
//

protocol PdfDelegate : class {
    func alertInvalidUrl()
    func alertInvalidDocument()
    func startIndicator()
    func stopIndicator()
}
