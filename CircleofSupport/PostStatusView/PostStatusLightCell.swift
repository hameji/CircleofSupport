//
//  PostStatusLightCell.swift
//  CircleofSupport
//
//  Created by Hajime Taniguchi on 2019/10/23.
//  Copyright © 2019 Hajime Taniguchi. All rights reserved.
//

import UIKit

class PostStatusLightCell: UICollectionViewCell {
 
    @IBOutlet weak var lightImageView: UIImageView!
    @IBOutlet weak var lightDescription: UILabel!
    
    func bind(data: PostStatusSelectedData) {
        if data.isSelected {
            self.lightImageView.image = UIImage(named: "lightOn.png")
            self.lightDescription.text = "電気は開通しています。"
        } else {
            self.lightImageView.image = UIImage(named: "lightOff.png")
            self.lightDescription.text = "電気は不通です。"
        }
    }
}
