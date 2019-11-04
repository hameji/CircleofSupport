//
//  RssTitleViewController.swift
//  CircleofSupport
//
//  Created by Hajime Taniguchi on 2019/11/01.
//  Copyright © 2019 Hajime Taniguchi. All rights reserved.
//

import UIKit
import SVProgressHUD

class RssViewController: UIViewController {
    
    // MARK: - vars & lets
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var showHPButton: UIBarButtonItem!
    @IBOutlet weak var categorySegment: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    private let rssPresenter = RssPresenter()
    
    private static let segueToPdfViewer = "toPdfViewer"
    private static let segueToWebView = "toWebView"

    // MARK: - Program Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.rssPresenter.rssView = self
        let longPressed = UILongPressGestureRecognizer(target: self, action: #selector(segmentLongPressed))
        self.categorySegment.addGestureRecognizer(longPressed)
        self.rssPresenter.viewDidLoad(segment: categorySegment.selectedSegmentIndex)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.rssPresenter.viewWillAppear(segment: categorySegment.selectedSegmentIndex)
    }
    
    @IBAction func showHPButtonPressed(_ sender: UIBarButtonItem) {
        self.rssPresenter.showHPButtonPressed(sender: sender)
    }
    
    @IBAction func changedSegment(_ sender: UISegmentedControl) {
        self.rssPresenter.changedSegment(segment: sender.selectedSegmentIndex)
    }
    
    @objc func segmentLongPressed() {
        print("longPressed")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch sender {
        case nil:
            if segue.identifier == RssViewController.segueToWebView {
                let url = self.rssPresenter.getHPUrlForSegment(segment: self.categorySegment.selectedSegmentIndex)
                let webView = segue.destination as? WebViewController
                webView?.url = url
            }
        case is UITableViewCell:
            if segue.identifier == RssViewController.segueToPdfViewer {
                let cell = sender as! RssFeedCell
                let rssDetail = segue.destination as? PdfViewController
                rssDetail?.url = cell.url
            }
        default: break
        }
    }
    
}

extension RssViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.rssPresenter.didSelectRowAt(indexPath: indexPath)
    }
}

extension RssViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.rssPresenter.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = self.rssPresenter.cellForRowAt(indexPath: indexPath)
        switch cellType {
        case .feedCell:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "rssFeedCell") as! RssFeedCell
            let item = self.rssPresenter.getFeedItemfor(indexPath: indexPath)
            cell.bind(feedItem: item)
            return cell
        case .alert:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "rssAlertCell") as! RssAlertCell
            return cell
        case .agency:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "rssAgencyCell") as! RssAgencyCell
            return cell
        }
    }
    
}

extension RssViewController: RssDelegate {
    func changeSegmentName(index: Int, name: String) {
        self.categorySegment.setTitle(name, forSegmentAt: index)
    }
    
    func reloadTableView() {
        self.tableView.reloadData()
    }

    func segueToWebView(indexPath: IndexPath) {
        self.performSegue(withIdentifier: RssViewController.segueToWebView, sender: self.tableView.cellForRow(at: indexPath))
    }

    func segueToPDFView(indexPath: IndexPath) {
        self.performSegue(withIdentifier: RssViewController.segueToPdfViewer, sender: self.tableView.cellForRow(at: indexPath))
    }
    
    func startIndicator() {
        self.tableView.isUserInteractionEnabled = false
        self.categorySegment.isUserInteractionEnabled = false
        self.activityIndicator.alpha = 1.0
        self.activityIndicator.startAnimating()
    }
    
    func stopIndicator() {
        self.activityIndicator.stopAnimating()
        self.activityIndicator.alpha = 0.0
        self.categorySegment.isUserInteractionEnabled = true
        self.tableView.isUserInteractionEnabled = true
    }
    
    func enableShowHP(bool: Bool) {
        self.showHPButton.isEnabled = bool
    }

}
