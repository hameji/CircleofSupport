//
//  FeedItem.swift
//  CircleofSupport
//
//  Created by Hajime Taniguchi on 2019/11/02.
//  Copyright © 2019 Hajime Taniguchi. All rights reserved.
//

class FeedItem {
    var title: String!
    var date: String!
    var url: String!
    
    func write(title: String, date: String, url: String) {
        self.title = title
        self.date = date
        self.url = url
    }
}
