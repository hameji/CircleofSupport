//
//  RssTitlePresenter.swift
//  CircleofSupport
//
//  Created by Hajime Taniguchi on 2019/11/01.
//  Copyright © 2019 Hajime Taniguchi. All rights reserved.
//

import UIKit

class RssTitlePresenter {

    // MARK: - vars & lets
    private let authentication = Authentication()
    weak var rssTitleView: RssTitleDelegate?
    
    func viewDidLoad() {
    }
    
    func changedSegment(segment: Int) {
        switch segment {
        default: break
        }
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        return 5
    }

    func cellForRowAt(indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

}
