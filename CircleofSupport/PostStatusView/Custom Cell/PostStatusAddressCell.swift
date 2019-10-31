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
    
    var delegate: PostStatusAddressDelegate?
    
    func bind(data: PostStatusAddressData) {
        if let address = data.address {
            self.address.text = address
        } else {
            self.address.text = "現住所を特定できません。"
            placeSegment.selectedSegmentIndex = 0
        }
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        self.delegate?.segmentChanged(index: sender.selectedSegmentIndex)
    }
    
}
