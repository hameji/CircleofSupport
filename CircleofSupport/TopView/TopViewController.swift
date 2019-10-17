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
    private static let segueMainView = "toMain"

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
    func segueToMain() {
        self.performSegue(withIdentifier: TopViewController.segueMainView, sender: nil)
    }
    
    func alertLoginFailed() {
        let alert = UIAlertController(title: "ログインに失敗しました。\nしばらくしてから再度試みてください。", message: nil, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "はい", style: .default, handler: { _ in
            self.actionButton.alpha = 1.0
        })
        alert.addAction(yesAction)
        self.present(alert, animated: true, completion: nil)
    }
}

