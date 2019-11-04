//
//  RssTitleCustomCell.swift
//  CircleofSupport
//
//  Created by Hajime Taniguchi on 2019/11/02.
//  Copyright © 2019 Hajime Taniguchi. All rights reserved.
//

import UIKit

class RssFeedCell: UITableViewCell {
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var item: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var content: UILabel!

    var url: String!
    
    func bind(feedItem: FeedItem) {
        self.date.text = feedItem.date
        self.title.text = feedItem.title
        self.url = feedItem.url
    }
}
