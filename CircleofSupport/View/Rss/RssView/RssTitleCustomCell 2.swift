//
//  RssTitleCustomCell.swift
//  CircleofSupport
//
//  Created by Hajime Taniguchi on 2019/11/02.
//  Copyright © 2019 Hajime Taniguchi. All rights reserved.
//

import UIKit

class RssTitleCustomCell: UITableViewCell {
    
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var title: UILabel!
    
    func bind(feedItem: FeedItem) {
        print(feedItem.title)
        self.date.text = feedItem.date
        self.title.text = feedItem.title
    }
}
