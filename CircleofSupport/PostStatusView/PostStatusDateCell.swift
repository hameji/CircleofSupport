//
//  PostStatusDateCell.swift
//  CircleofSupport
//
//  Created by Hajime Taniguchi on 2019/10/23.
//  Copyright © 2019 Hajime Taniguchi. All rights reserved.
//

import UIKit

class PostStatusDateCell: UICollectionViewCell {
    
    @IBOutlet weak var date: UILabel!
    
    func bind(data: PostStatusDateData) {
        self.date.text = data.date    
    }
}