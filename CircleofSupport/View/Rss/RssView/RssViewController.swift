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
    @IBOutlet weak var categorySegment: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    private let rssPresenter = RssPresenter()
    
    private static let segueToPdfViewer = "toPdfViewer"
    private static let segueToWebView = "toWebView"

    // MARK: - Program Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.rssPresenter.rssView = self
        self.rssPresenter.viewDidLoad(segment: categorySegment.selectedSegmentIndex)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.rssPresenter.viewWillAppear(segment: categorySegment.selectedSegmentIndex)
    }
    
    @IBAction func changedSegment(_ sender: UISegmentedControl) {
        self.rssPresenter.changedSegment(segment: sender.selectedSegmentIndex)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == RssViewController.segueToPdfViewer {
            if sender is RssTitleCustomCell {
                let cell = sender as! RssTitleCustomCell
                let rssDetail = segue.destination as? PdfViewController
                rssDetail?.url = cell.url
            }
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
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "itemCell") as! RssTitleCustomCell
        let item = self.rssPresenter.cellForRowAt(indexPath: indexPath)
        cell.bind(feedItem: item)
        return cell
    }
    
}

extension RssViewController: RssDelegate {
    func reloadTableView() {
        self.tableView.reloadData()
    }

    func segueToWebView(indexPath: IndexPath) {
        self.performSegue(withIdentifier: RssViewController.segueToWebView, sender: self.tableView.cellForRow(at: indexPath))
    }

    func segueToPDFView(indexPath: IndexPath) {
        self.performSegue(withIdentifier: RssViewController.segueToPdfViewer, sender: self.tableView.cellForRow(at: indexPath))
    }
    
    func showHUD() {
        print("HUDを表示する")
    }
    
    func hideHUD() {
        print("HUD隠す")
    }
}
