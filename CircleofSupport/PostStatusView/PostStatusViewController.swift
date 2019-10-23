//
//  PostStatusViewController.swift
//  CircleofSupport
//
//  Created by Hajime Taniguchi on 2019/10/23.
//  Copyright © 2019 Hajime Taniguchi. All rights reserved.
//


import UIKit

class PostStatusViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private let postStatusPresenter = PostStatusPresenter()
    
    // MARK: - Program Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.postStatusPresenter.postStatusView = self
    }

}

extension PostStatusViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.postStatusPresenter.numberOfItemsInSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    }
    
    
}

extension PostStatusViewController: UICollectionViewDelegate {
    
}



// MARK: - TopViewDelegate
extension PostStatusViewController: PostStatusDelegate {

}
