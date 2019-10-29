//
//  PostStatusGassCell.swift
//  CircleofSupport
//
//  Created by Hajime Taniguchi on 2019/10/23.
//  Copyright © 2019 Hajime Taniguchi. All rights reserved.
//

import UIKit

class PostStatusGassCell: UICollectionViewCell {
    
    @IBOutlet weak var gassImageView: UIImageView!
    @IBOutlet weak var gassDescription: UILabel!
    
    func bind(data: PostStatusSelectedData) {
        if data.isSelected {
            self.gassImageView.image = UIImage(named: "gassOn.png")
            self.gassDescription.text = "ガスは開通しています。"
        } else {
            self.gassImageView.image = UIImage(named: "gassOff.png")
            self.gassDescription.text = "ガスは不通です。"
        }
    }

}
