//
//  SNSViewController.swift
//  CircleofSupport
//
//  Created by Hajime Taniguchi on 2019/11/05.
//  Copyright © 2019 Hajime Taniguchi. All rights reserved.
//

import UIKit

class SNSViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var twitterButton = UIButton(type: .custom)
    var facebookButton = UIButton(type: .custom)
    var lineButton = UIButton(type: .custom)
    var youtubeButton = UIButton(type: .custom)

    private let snsPresenter = SNSPresenter()
    var tweets: [Tweet] = []

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
        twitterButton.setImage(UIImage(named: "twitter.png"), for: .selected)
        twitterButton.addTarget(self, action: #selector(tappedTwitter), for: .touchUpInside)

        facebookButton.frame = CGRect(x: imgWidth + spacer, y: 10, width: 25, height: 25)
        facebookButton.setImage(UIImage(named: "facebook.png"), for: .normal)
        facebookButton.setImage(UIImage(named: "facebook.png"), for: .selected)
        facebookButton.imageView?.tintColor = UIColor.gray
        facebookButton.addTarget(self, action: #selector(tappedFacebook), for: .touchUpInside)

        lineButton.frame = CGRect(x: 2 * (imgWidth + spacer), y: 10, width: 25, height: 25)
        lineButton.setImage(UIImage(named: "line.png"), for:.normal)
        lineButton.setImage(UIImage(named: "line.png"), for:.selected)
        lineButton.imageView?.tintColor = UIColor.gray
        lineButton.addTarget(self, action: #selector(tappedLine), for: .touchUpInside)

        youtubeButton.frame = CGRect(x: 3 * (imgWidth + spacer), y: 10, width: 25, height: 25)
        youtubeButton.setImage(UIImage(named: "youtube.png"), for: .normal)
        youtubeButton.setImage(UIImage(named: "youtube_selected.png"), for: .selected)
        youtubeButton.imageView?.tintColor = UIColor.gray
        youtubeButton.addTarget(self, action: #selector(tappedYoutube), for: .touchUpInside)
        centerView.addSubview(twitterButton)
        centerView.addSubview(facebookButton)
        centerView.addSubview(lineButton)
        centerView.addSubview(youtubeButton)

        navigationItem.titleView = centerView
        navigationItem.titleView?.center = centerView.center
    }
    
    @objc func tappedTwitter() {
        facebookButton.imageView?.tintColor = UIColor.gray
        lineButton.imageView?.tintColor = UIColor.gray
        youtubeButton.imageView?.tintColor = UIColor.gray
        print("A")
    }

    @objc func tappedFacebook() {
        twitterButton.imageView?.tintColor = UIColor.gray
        lineButton.imageView?.tintColor = UIColor.gray
        youtubeButton.imageView?.tintColor = UIColor.gray
        print("A")
    }

    @objc func tappedLine() {
        twitterButton.imageView?.tintColor = UIColor.gray
        facebookButton.imageView?.tintColor = UIColor.gray
        youtubeButton.imageView?.tintColor = UIColor.gray
        print("A")
    }

    @objc func tappedYoutube() {
        twitterButton.imageView?.tintColor = UIColor.gray
        facebookButton.imageView?.tintColor = UIColor.gray
        lineButton.imageView?.tintColor = UIColor.gray
        print("A")
    }

}

extension SNSViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}

extension SNSViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        return cell!
    }
    
    
}

extension SNSViewController: SNSDelegate {
    
}
