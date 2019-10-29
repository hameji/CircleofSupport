//
//  PostStatusAddressCell.swift
//  CircleofSupport
//
//  Created by Hajime Taniguchi on 2019/10/23.
//  Copyright © 2019 Hajime Taniguchi. All rights reserved.
//

import UIKit

class PostStatusAddressCell: UICollectionViewCell {
    
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var placeSegment: UISegmentedControl!
    
    func bind(data: PostStatusAddressData) {
        self.address.text = data.address
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
    }
    
}
