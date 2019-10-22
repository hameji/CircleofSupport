//
//  PostStatusViewController.swift
//  CircleofSupport
//
//  Created by Hajime Taniguchi on 2019/10/23.
//  Copyright © 2019 Hajime Taniguchi. All rights reserved.
//


import UIKit

class PostStatusViewController: UIViewController {

    private let postStatusPresenter = PostStatusPresenter()
    
    // MARK: - Program Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.postStatusPresenter.postStatusView = self
    }

}

// MARK: - TopViewDelegate
extension PostStatusViewController: PostStatusDelegate {

}
