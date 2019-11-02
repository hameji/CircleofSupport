//
//  Authentication.swift
//  CircleofSupport
//
//  Created by Hajime Taniguchi on 2019/10/17.
//  Copyright © 2019 Hajime Taniguchi. All rights reserved.
//

import Firebase

class Authentication {
    
    func getCurrentUser() -> User? {
        return Auth.auth().currentUser
    }
    
    func loginAnonymously(completion: @escaping (Result<User, Error>) ->()) {
        Auth.auth().signInAnonymously() { authResult, error in
            if let error = error {
                print(error)
                completion(.failure(error))
                return
            }
            print(" ... successfully logedin anonymously.")
            let user = authResult!.user
            completion(.success(user))
        }
    }

}
