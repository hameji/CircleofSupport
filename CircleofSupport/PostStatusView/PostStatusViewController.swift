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
        self.postStatusPresenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.postStatusPresenter.viewWillAppear()
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.postStatusPresenter.viewWillDisappear()
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
        case .dateCell(let data):
            let dateCell = collectionView.dequeueReusableCell(withReuseIdentifier: "dateCell", for: indexPath) as! PostStatusDateCell
            dateCell.bind(data: data)
            return dateCell
        case .addressCell(let data):
            let addressCell = collectionView.dequeueReusableCell(withReuseIdentifier: "addressCell", for: indexPath) as! PostStatusAddressCell
            addressCell.bind(data: data)
            return addressCell
        case .lightCell(let data):
            let lightCell = collectionView.dequeueReusableCell(withReuseIdentifier: "lightCell", for: indexPath) as! PostStatusLightCell
            lightCell.bind(data: data)
            return lightCell
        case .gassCell(let data):
            let gassCell = collectionView.dequeueReusableCell(withReuseIdentifier: "gassCell", for: indexPath) as! PostStatusGassCell
            gassCell.bind(data: data)
            return gassCell
        case .waterCell(let data):
            let waterCell = collectionView.dequeueReusableCell(withReuseIdentifier: "waterCell", for: indexPath) as! PostStatusWaterCell
            waterCell.bind(data: data)
            return waterCell
        }
    }
    
    
}

extension PostStatusViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected:", indexPath)
        self.postStatusPresenter.didSelectItemAt(indexPath: indexPath)
    }
}



// MARK: - TopViewDelegate
extension PostStatusViewController: PostStatusDelegate {
    func reloadCollectionView() {
        self.collectionView.reloadData()
    }
}
