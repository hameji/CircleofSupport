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
        if let date = data.date {
            let df = DateFormatter()
            df.locale = Locale(identifier: "en_US_POSIX")
            df.dateStyle = .medium
            df.timeStyle = .none
            self.date.text = df.string(from: date)
        } else {
            self.date.text = "送信記録なし"
        }
    }
}
