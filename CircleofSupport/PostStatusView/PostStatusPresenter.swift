//
//  PostStatusPresenter.swift
//  CircleofSupport
//
//  Created by Hajime Taniguchi on 2019/10/23.
//  Copyright © 2019 Hajime Taniguchi. All rights reserved.
//

import UIKit

class PostStatusPresenter {
    
    private let cells:[PostStatusPresentCell]

    // MARK: - vars & lets
    weak var postStatusView: PostStatusDelegate?

    init() {
        self.cells = [.dateCell,
                      .addressCell(PostStatusAddressData(address: "")),
                      .lightCell,
                      .gassCell,
                      .waterCell]
    }
    
    // MARK: - Program Lifecycle
    func viewDidLoad() {
    }
    
    func numberOfItemsInSection() -> Int {
        return self.cells.count
    }

}
