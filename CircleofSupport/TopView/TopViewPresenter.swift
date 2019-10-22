//
//  TopViewPresenter.swift
//  CircleofSupport
//
//  Created by Hajime Taniguchi on 2019/10/17.
//  Copyright © 2019 Hajime Taniguchi. All rights reserved.
//

import UIKit

class TopViewPresenter {

    // MARK: - vars & lets
    private let authentication = Authentication()
    weak var topView: TopViewDelegate?
    
    func viewDidLoad() {
        self.initializer()
    }

    private func initializer() {
        authentication.loginAnonymously() { result in
            guard case .success(let _) = result else {
                print("login failed")
                self.topView?.alertLoginFailed()
                return
            }
            print("login succeeded")
            self.topView?.segueToMain()
            return
        }
    }

    func actionButtonPressed() {
        if authentication.getCurrentUser() != nil {
            self.topView?.segueToMain()
        }
        self.initializer()
    }
}
