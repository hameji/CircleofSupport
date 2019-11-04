//
//  SNSViewController.swift
//  CircleofSupport
//
//  Created by Hajime Taniguchi on 2019/11/05.
//  Copyright © 2019 Hajime Taniguchi. All rights reserved.
//

import UIKit

class SNSViewController: UIViewController {
    
    private let snsPresenter = SNSPresenter()
    var twitterButton = UIButton(type: .system)
    var facebookButton = UIButton(type: .system)
    var lineButton = UIButton(type: .system)
    var youtubeButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationButton()
        self.snsPresenter.snsView = self
    }
    
    func setNavigationButton() {
        
        let centerView = UIView()
        let imgWidth = 25
        let spacer = 40
        centerView.frame = CGRect(x: 0, y: 0, width: imgWidth * 4 + spacer * 3, height: 44)
        
        twitterButton.frame = CGRect(x: 0, y: 10, width: 25, height: 25)
        twitterButton.setImage(UIImage(named: "twitter.png"), for: .normal)
        twitterButton.addTarget(self, action: #selector(tappedTwitter), for: .touchUpInside)

        facebookButton.frame = CGRect(x: imgWidth + spacer, y: 10, width: 25, height: 25)
        facebookButton.setImage(UIImage(named: "facebook.png"), for: .normal)
        facebookButton.imageView?.tintColor = UIColor.gray
        facebookButton.addTarget(self, action: #selector(tappedTwitter), for: .touchUpInside)

        lineButton.frame = CGRect(x: 2 * (imgWidth + spacer), y: 10, width: 25, height: 25)
        lineButton.setImage(UIImage(named: "line.png"), for:.normal)
        lineButton.imageView?.tintColor = UIColor.gray
        lineButton.addTarget(self, action: #selector(tappedTwitter), for: .touchUpInside)

        youtubeButton.frame = CGRect(x: 3 * (imgWidth + spacer), y: 10, width: 25, height: 25)
        youtubeButton.imageView?.image = UIImage(named: "")
        youtubeButton.imageView?.tintColor = UIColor.gray
        youtubeButton.addTarget(self, action: #selector(tappedTwitter), for: .touchUpInside)
        centerView.addSubview(twitterButton)
        centerView.addSubview(facebookButton)
        centerView.addSubview(lineButton)
        centerView.addSubview(youtubeButton)

        navigationItem.titleView = centerView
        navigationItem.titleView?.center = centerView.center
    }
    
    @objc func tappedTwitter() {
        print("A")
    }
}

extension SNSViewController: UITableViewDelegate {
    
}

extension SNSViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        return cell!
    }
    
    
}

extension SNSViewController: SNSDelegate {
    
}
