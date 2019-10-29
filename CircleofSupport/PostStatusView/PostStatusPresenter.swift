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
    var lastPost: Date? =  nil
    var address: String? = nil
    var lightSelected: Bool = false
    var gassSelected: Bool = false
    var waterSelected: Bool = false
    
    // MARK: - vars & lets
    weak var postStatusView: PostStatusDelegate?

    init() {
        self.cells = [.dateCell(PostStatusDateData(date: lastPost)),
                      .addressCell(PostStatusAddressData(address: address)),
                      .lightCell(PostStatusSelectedData(isSelected: lightSelected)),
                      .gassCell(PostStatusSelectedData(isSelected: lightSelected)),
                      .waterCell(PostStatusSelectedData(isSelected: lightSelected))]
    }
    
    // MARK: - Program Lifecycle
    func viewDidLoad() {
    }
    
    // MARK: - UICollectionView DelegateFlowLayout
    func sizeForItemAt(viewWidth: CGFloat, indexPath: IndexPath) -> CGSize {
        var eachHeight: Int = 0
        let celltype = cellForItemAt(indexPath: indexPath)
        switch celltype {
        case .dateCell:
            eachHeight = 40
        case .addressCell( _):
            eachHeight = 90
        default:
            eachHeight = 260
        }
        return CGSize(width: viewWidth, height: CGFloat(eachHeight))
    }

    func numberOfItemsInSection() -> Int {
        return self.cells.count
    }

    func cellForItemAt(indexPath: IndexPath) -> PostStatusPresentCell {
        return self.cells[indexPath.row]
    }
}
