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
    private let rssTitlePresenter = RssTitlePresenter()
    
    private static let segueToPdfViewer = "toPdfViewer"
    private static let segueToWebView = "toWebView"

    // MARK: - Program Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.rssTitlePresenter.rssTitleView = self
        self.rssTitlePresenter.viewDidLoad(segment: categorySegment.selectedSegmentIndex)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.rssTitlePresenter.viewWillAppear(segment: categorySegment.selectedSegmentIndex)
    }
    
    @IBAction func changedSegment(_ sender: UISegmentedControl) {
        self.rssTitlePresenter.changedSegment(segment: sender.selectedSegmentIndex)
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

extension RssTitleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.rssTitlePresenter.didSelectRowAt(indexPath: indexPath)
    }
}

extension RssTitleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.rssTitlePresenter.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "itemCell") as! RssTitleCustomCell
        let item = self.rssTitlePresenter.cellForRowAt(indexPath: indexPath)
        cell.bind(feedItem: item)
        return cell
    }
    
}

extension RssTitleViewController: RssTitleDelegate {
    func reloadTableView() {
        self.tableView.reloadData()
    }
    
    func segueToDetail(indexPath: IndexPath) {
        self.performSegue(withIdentifier: RssTitleViewController.segueToPdfViewer, sender: self.tableView.cellForRow(at: indexPath))
    }
    
    func showHUD() {
        print("HUDを表示する")
    }
    
    func hideHUD() {
        print("HUD隠す")
    }
}
