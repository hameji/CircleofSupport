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

    private let firestoreManager = FirestoreManager()

    // MARK: - Program Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.topViewPresenter.topView = self
        self.topViewPresenter.viewDidLoad()
    }
    
    @IBAction func actionButtonPressed(_ sender: UIButton) {
        self.topViewPresenter.actionButtonPressed()
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

//extension TopViewController {
//    func addTotalRss() {
//        for i in 0 ..< AddressData.prefecture.count {
//            for j in 0 ..< AddressData.returnAdressArray()[i].count {
//                addRssFeed(total: AddressData.returnAdressArray()[i].count, current: j + i, category: AddressData.prefecture[i], authority: AddressData.returnAdressArray()[i][j])
//            }
//        }
//    }
//    
//    func addRssFeed(total: Int, current: Int, category: String, authority: String) {
//        let data0: [String:Any] = ["Category": category, "Authority" : authority, "Url" : "http://www.", "Error" : true, "Verified" : false]
//        firestoreManager.addData(collectionName: "Rss", data: data0) { result in
//            print("finished", current, "/", total, "[", category, "]", authority, result)
//        }
//    }
//
//    func addRssFeed(category: String, authority: String, url: String) {
//        let data0: [String:Any] = ["Category": category, "Authority" : authority, "Url" : url, "Error" : false, "Verified" : true]
//        firestoreManager.addData(collectionName: "Rss", data: data0) { result in
//        }
//    }
//
//}
