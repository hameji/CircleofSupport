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

    @IBAction func postButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PostStatusViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return postStatusPresenter.sizeForItemAt(viewWidth: self.view.bounds.width, indexPath: indexPath)
    }
    
}


extension PostStatusViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.postStatusPresenter.numberOfItemsInSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellType = self.postStatusPresenter.cellForItemAt(indexPath: indexPath)
        switch cellType {
        case .dateCell:
            let dateCell = collectionView.dequeueReusableCell(withReuseIdentifier: "dateCell", for: indexPath)
            return dateCell
        case .addressCell(let data):
            let addressCell = collectionView.dequeueReusableCell(withReuseIdentifier: "addressCell", for: indexPath)
            return addressCell
        case .lightCell:
            let lightCell = collectionView.dequeueReusableCell(withReuseIdentifier: "lightCell", for: indexPath)
            return lightCell
        case .gassCell:
            let gassCell = collectionView.dequeueReusableCell(withReuseIdentifier: "gassCell", for: indexPath)
            return gassCell
        case .waterCell:
            let waterCell = collectionView.dequeueReusableCell(withReuseIdentifier: "waterCell", for: indexPath)
            return waterCell
        }
    }
    
    
}

extension PostStatusViewController: UICollectionViewDelegate {
    
}



// MARK: - TopViewDelegate
extension PostStatusViewController: PostStatusDelegate {

}
