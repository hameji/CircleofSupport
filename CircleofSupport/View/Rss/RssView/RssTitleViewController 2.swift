//
//  RssTitleViewController.swift
//  CircleofSupport
//
//  Created by Hajime Taniguchi on 2019/11/01.
//  Copyright © 2019 Hajime Taniguchi. All rights reserved.
//

import UIKit

class RssTitleViewController: UIViewController {
    
    // MARK: - vars & lets
    @IBOutlet weak var categorySegment: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    private let rssTitlePresenter = RssTitlePresenter()
    
    // MARK: - Program Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.rssTitlePresenter.rssTitleView = self
        self.rssTitlePresenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.rssTitlePresenter.viewWillAppear(segment: categorySegment.selectedSegmentIndex)
    }
    
    @IBAction func changedSegment(_ sender: UISegmentedControl) {
        self.rssTitlePresenter.changedSegment(segment: sender.selectedSegmentIndex)
    }
    
}

extension RssTitleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 200
        return UITableView.automaticDimension
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
}
