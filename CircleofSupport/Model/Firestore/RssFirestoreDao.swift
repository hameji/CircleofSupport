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
    
    private let firestoreManager = FirestoreManager()
    private let rssRef = "Authorities"
    
    private let keyRssID = "rssID"
    private let keyCategory = "Category"
    private let keyAuthority = "Authority"
    private let keyRssfeeds = "Rssfeeds"
    private let keyUrl = "Url"
    private let keyError = "Error"
    private let keyVerified = "Verified"
    
    // MARK: -- Functions
    func fetchRssfeeds(category: String, authority: String, completion: @escaping (Result<[[String:String]], Error>) -> ()) {
        self.firestoreManager.getCollectionData(collectionName: "Authorities", document: category+authority, collection: "Rssfeeds") { result in
            guard case .success (let documents) = result else {
                completion(.failure(result as! Error))
                return
            }
            guard !(documents.isEmpty) else {
                print(" ... there was no rssfeeds. returning []")
                completion(.success([]))
                return
            }
            let rss: [[String: String]] = documents.map {
                [ "Item" : $0.data["Item"] as! String, "Url" : $0.data["Url"] as! String ]
            }
            completion(.success(rss))
        }
    }

    func fetchHomepageUrl(category: String, authority: String, completion: @escaping (Result<String?, Error>) -> ()) {
        self.firestoreManager.getDocumentData(collectionName: "Authorities", document: category+authority) { result in
            guard case .success(let document) = result else {
                completion(.failure(result as! Error))
                return
            }
            guard let data0 = document?.data else {
                completion(.success(nil))
                return
            }
            let url = data0[self.keyUrl] as! String
            completion(.success(url))
        }
    }

}
