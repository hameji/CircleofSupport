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
    private let rssRef = "Authorities"
    
    private let keyRssID = "rssID"
    private let keyCategory = "Category"
    private let keyAuthority = "Authority"
    private let keyRssfeeds = "Rssfeeds"
    private let keyUrl = "Url"
    private let keyError = "Error"
    private let keyVerified = "Verified"
    
    // MARK: -- Functions
    func getDocumentID(category: String, authority: String, completion: @escaping (Result<String?, Error>) -> ()) {
        let query = self.firestore.collection(self.rssRef).whereField(self.keyAuthority, isEqualTo: authority).whereField(self.keyCategory, isEqualTo: category)
        firestoreManager.getlimitedField(limit: query) { result in
            guard case .success(let document) = result else {
                completion(.failure(result as! Error))
                return
            }
            guard let data = document.first else {
                print(" ... there was no document for ", authority, "at", category)
                completion(.success(nil))
                return
            }
            completion(.success(data.documentID))
        }
    }
    
    func fetchRssfeeds(category: String, authority: String, completion: @escaping (Result<[[String:String]], Error>) -> ()) {
        getDocumentID(category: category, authority: authority) { result in
            guard case .success(let data) = result else {
                completion(.failure(result as! Error))
                return
            }
            guard let documentID = data else {
                print(" ... documentID was nil, returning []")
                completion(.success([]))
                return
            }
            let query = self.firestore.collection(self.rssRef).document(documentID).collection(self.keyRssfeeds)
            self.firestoreManager.getlimitedField(limit: query) { result in
                guard case .success(let rssfeeds) = result else {
                    completion(.failure(result as! Error))
                    return
                }
                guard let _ = rssfeeds.first else {
                    print(" ... there was no rssfeeds. returning []")
                    completion(.success([]))
                    return
                }
                let rss: [[String: String]] = rssfeeds.map {
                    [ "Item" : $0.data["Item"] as! String, "Url" : $0.data["Url"] as! String ]
                }
                completion(.success(rss))
            }
        }
        
    }

    func fetchHomepageUrl(category: String, authority: String, completion: @escaping (Result<String, Error>) -> ()) {
        let query = self.firestore.collection(self.rssRef).whereField(self.keyAuthority, isEqualTo: authority).whereField(self.keyCategory, isEqualTo: category)
        firestoreManager.getlimitedField(limit: query) { result in
            guard case .success(let document) = result else {
                completion(.failure(result as! Error))
                return
            }
            guard let data = document.first?.data else {
                print(" ... there was no matched data at", category, "/", authority)
                return
            }
            let url = data[self.keyUrl] as! String
            completion(.success(url))
        }
    }

}
