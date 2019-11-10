//
//  ConfirmSafetyViewController.swift
//  CircleofSupport
//
//  Created by Hajime Taniguchi on 2019/11/06.
//  Copyright © 2019 Hajime Taniguchi. All rights reserved.
//

import UIKit

class ConfirmSafetyViewController: UIViewController {
    
    
    @IBOutlet weak var youtubeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func youtubeButtonPressed(_ sender: Any) {
        youtubeButton.setImage(UIImage(named: "youtube_selected.png"), for: .normal)
    }
    
    
}
