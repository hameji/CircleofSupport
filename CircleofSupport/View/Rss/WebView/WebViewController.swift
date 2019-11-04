//
//  PdfViewerViewController.swift
//  CircleofSupport
//
//  Created by Hajime Taniguchi on 2019/11/02.
//  Copyright © 2019 Hajime Taniguchi. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    var url: String!
    
    // MARK: - Program Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print(url)
    }
}
