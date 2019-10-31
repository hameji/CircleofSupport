//
//  MainTabBarController.swift
//  CircleofSupport
//
//  Created by Hajime Taniguchi on 2019/10/31.
//  Copyright © 2019 Hajime Taniguchi. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard let items = self.tabBar.items else { return }
        for item in items {
            item.title = nil
            item.imageInsets = UIEdgeInsets(top: 9, left: 0, bottom: -9, right: 0)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
