//
//  ViewController.swift
//  CircleofSupport
//
//  Created by Hajime Taniguchi on 2019/10/17.
//  Copyright © 2019 Hajime Taniguchi. All rights reserved.
//

import UIKit

class TopViewController: UIViewController {

    // MARK: - vars & lets
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var actionButton: UIButton!
    
    private let topViewPresenter = TopViewPresenter()

    // MARK: - Program Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.topViewPresenter.topView = self
        self.topViewPresenter.viewDidLoad()
    }
}

// MARK: - TopViewDelegate
extension TopViewController: TopViewDelegate {
    
}

