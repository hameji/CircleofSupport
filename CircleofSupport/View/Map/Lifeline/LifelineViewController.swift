//
//  PostStatusViewController.swift
//  CircleofSupport
//
//  Created by Hajime Taniguchi on 2019/10/23.
//  Copyright © 2019 Hajime Taniguchi. All rights reserved.
//


import UIKit

class LifelineViewController: UIViewController {
    
    @IBOutlet weak var actionButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    var actionMode = 0  // 0: post, 1: gpsStart
    
    private let lifelinePresenter = LifelinePresenter()
    
    // MARK: - Program Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.lifelinePresenter.lifelineView = self
        self.lifelinePresenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.lifelinePresenter.viewWillAppear()
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.lifelinePresenter.viewWillDisappear()
    }
    
    @IBAction func dismissButtonPressed(_ sender: UIBarButtonItem) {
        self.lifelinePresenter.dismissButtonPressed()
    }
    
    @IBAction func actionButtonPressed(_ sender: Any) {
        self.lifelinePresenter.actionButtonPressed(mode: actionMode)
    }
        
    private func changeButtonName() {
        switch actionMode {
        case 0:
            self.actionButton.title = "GPS取得"
        case 1:
            self.actionButton.title = "送信"
        default: break
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension LifelineViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return lifelinePresenter.sizeForItemAt(viewWidth: self.view.bounds.width, indexPath: indexPath)
    }
    
}


extension LifelineViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.lifelinePresenter.numberOfItemsInSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellType = self.lifelinePresenter.cellForItemAt(indexPath: indexPath)
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

extension LifelineViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected:", indexPath)
        self.lifelinePresenter.didSelectItemAt(indexPath: indexPath)
    }
}



// MARK: - TopViewDelegate
extension LifelineViewController: LifelineDelegate {
    func reloadCollectionView() {
        self.collectionView.reloadData()
    }
    
    func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func alertGPSdisabled() {
        let alert = UIAlertController(title: "GPS機能がOFFになっています。\nこのアプリを利用するにはONにして下さい。", message: nil, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "はい", style: .default, handler: { Void in
            self.dismissView()
        })
        alert.addAction(dismissAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func alertGPSfailed() {
        let alert = UIAlertController(title: "GPSを取得できませんでした。\n時間を置いて再度試して下さい。", message: nil, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "はい", style: .default, handler: { Void in
            self.actionMode = 0
            self.changeButtonName()
        })
        alert.addAction(yesAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func alertInvalidGPS() {
        let alert = UIAlertController(title: "有効なGPSを取得できませんでした。\n時間を置いて再度試して下さい。", message: nil, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "はい", style: .default, handler: { Void in
            self.actionMode = 0
            self.changeButtonName()
        })
        alert.addAction(yesAction)
        self.present(alert, animated: true, completion: nil)
    }

    func alertAddressConversionFailed() {
        let alert = UIAlertController(title: "住所の取得に失敗しました。", message: nil, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "はい", style: .default, handler: { Void in
            self.actionMode = 0
            self.changeButtonName()
        })
        alert.addAction(yesAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func changeToPostMode() {
        self.actionMode = 1
        self.changeButtonName()
    }
    
    func alertUnLoggedIn() {
        let alert = UIAlertController(title: "現在未ログインです。\nログインして下さい", message: nil, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "はい", style: .default, handler: { Void in
                // ここにログインを実装する
        })
        alert.addAction(yesAction)
        self.present(alert, animated: true, completion: nil)
    }

    func alertUpdateFailed() {
        let alert = UIAlertController(title: "データのアップロードに失敗しました。\n時間を置いて再度送信ください。", message: nil, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "はい", style: .cancel, handler: nil)
        alert.addAction(yesAction)
        self.present(alert, animated: true, completion: nil)
    }
}

extension LifelineViewController: PostStatusAddressDelegate {
    func segmentChanged(index: Int) {
        self.lifelinePresenter.segmentChanged(index: index)
    }
}
