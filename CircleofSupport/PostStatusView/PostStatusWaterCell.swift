//
//  PostStatusWaterCell.swift
//  CircleofSupport
//
//  Created by Hajime Taniguchi on 2019/10/23.
//  Copyright © 2019 Hajime Taniguchi. All rights reserved.
//

import UIKit

class PostStatusWaterCell: UICollectionViewCell {
    
    @IBOutlet weak var waterImageView: UIImageView!
    @IBOutlet weak var waterDescription: UILabel!
    
    func bind(data: PostStatusSelectedData) {
        if data.isSelected {
            self.waterImageView.image = UIImage(named: "waterOn.png")
            self.waterDescription.text = "水道は開通しています。"
        } else {
            self.waterImageView.image = UIImage(named: "waterOff.png")
            self.waterDescription.text = "水道は不通です。"
        }
    }

}
