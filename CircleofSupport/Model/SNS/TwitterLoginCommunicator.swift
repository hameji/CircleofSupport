//
//  TwitterLoginCommunicator.swift
//  CircleofSupport
//
//  Created by Hajime Taniguchi on 2019/11/05.
//  Copyright © 2019 Hajime Taniguchi. All rights reserved.
//

import Social
import Accounts

struct TwitterLoginCommunicator {
    func login(handler: @escaping (Bool) -> ()) {
        if !SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
            handler(false)
            return
        }
        
    }
}
