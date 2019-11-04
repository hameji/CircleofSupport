//
//  SettingsViewController.swift
//  CircleofSupport
//
//  Created by Hajime Taniguchi on 2019/11/05.
//  Copyright © 2019 Hajime Taniguchi. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    private let settingsPresenter = SettingsPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.settingsPresenter.settingsView = self
    }
}

extension SettingsViewController: UITableViewDelegate {
    
}

extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        return cell!
    }
    
    
}


extension SettingsViewController: SettingsDelegate {
    
}
