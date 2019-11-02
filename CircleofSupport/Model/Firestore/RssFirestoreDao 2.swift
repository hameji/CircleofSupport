//
//  RssFirestoreDao.swift
//  CircleofSupport
//
//  Created by Hajime Taniguchi on 2019/11/02.
//  Copyright © 2019 Hajime Taniguchi. All rights reserved.
//

import Foundation
import Firebase

class RssFirestoreDao {
    
    private lazy var firestore = Firestore.firestore()
    private let firestoreManager = FirestoreManager()
    private let rssRef = "Rss"
    
    private let keyRssID = "rssID"
    private let keyCategory = "Category"
    private let keyAuthority = "Authority"
    private let keyUrl = "Url"
    private let keyError = "Error"
    private let keyVerified = "Verified"
    
    // MARK: -- Functions
    func fetchRssUrl(category: String, authority: String, completion: @escaping (Result<String?, Error>) -> ()) {
        let query = self.firestore.collection(self.rssRef).whereField(self.keyAuthority, isEqualTo: authority).whereField(self.keyCategory, isEqualTo: category)
        firestoreManager.getlimitedField(limit: query) { result in
            guard case .success(let document) = result else {
                completion(.failure(result as! Error))
                return
            }
            let url = document.map { $0.data[self.keyUrl] as! String }.first
            completion(.success(url))
        }
    }
    
}
