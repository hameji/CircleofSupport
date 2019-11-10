//
//  FirestoreManager.swift
//  CircleofSupport
//
//  Created by Hajime Taniguchi on 2019/10/23.
//  Copyright © 2019 Hajime Taniguchi. All rights reserved.
//

import Firebase
import FirebaseAuth

class FirestoreManager {
    
    private lazy var firestore = Firestore.firestore()
    
    // MARK: -- Get Data(Total Data)
    func getData(collectionName: String, completion: @escaping (Result<[Document], Error>) -> ()) {
        self.firestore.collection(collectionName).getDocuments() {(querySnapshot, err) in
            guard let querySnapshot = querySnapshot else {
                completion(.failure(err!))
                return
            }
            
            print("querySnapshot:", querySnapshot)
            let result = querySnapshot.documents.map { Document(documentID: $0.documentID, data: $0.data()) }
            completion(.success(result))
        }
    }
    
    func getDocumentData(collectionName: String, document: String, completion: @escaping (Result<Document?, Error>) -> ()) {
        self.firestore.collection(collectionName).document(document).getDocument() { (querySnapshot, err) in
            guard let datum = querySnapshot else {
                completion(.failure(err!))
                return
            }
            guard let datum0 = datum.data() else {
                completion(.success(nil))
                return
            }
            let document0 = Document(documentID: datum.documentID, data: datum0)
            completion(.success(document0))
        }
    }
    
    func getCollectionData(collectionName: String, document: String, collection: String, completion: @escaping (Result<[Document], Error>) -> ()) {
        self.firestore.collection(collectionName).document(document).collection(collection).getDocuments() { (querySnapshot, err) in
            guard let querySnapshot = querySnapshot else {
                completion(.failure(err!))
                return
            }            
            let result = querySnapshot.documents.map { Document(documentID: $0.documentID, data: $0.data()) }
            completion(.success(result))
        }
    }


    // MARK: -- Get Data(Limited Data)
    // mapdata
    func getNewData(collectionName: String, date: Date, limit: Int, completion: @escaping (Result<[Document], Error>) -> ()) {
        var ref: Query
        if limit == 0 {
            ref = self.firestore.collection(collectionName).whereField("RegisterDate", isGreaterThanOrEqualTo: date)
        } else {
            ref = self.firestore.collection(collectionName).whereField("RegisterDate", isGreaterThanOrEqualTo: date).limit(to: limit)
        }
        ref.getDocuments() {(querySnapshot, err) in
            guard let querySnapshot = querySnapshot else {
                completion(.failure(err!))
                return
            }
            
            let result = querySnapshot.documents.map { Document(documentID: $0.documentID, data: $0.data()) }
            completion(.success(result))
        }
    }
    
    // Limit Field
    func getlimitedField(limit: Query, completion: @escaping (Result<[Document], Error>) -> ()) {
        limit.getDocuments() {(querySnapshot, err) in
            guard let querySnapshot = querySnapshot else {
                completion(.failure(err!))
                return
            }
            let result = querySnapshot.documents.map { Document(documentID: $0.documentID, data: $0.data()) }
            completion(.success(result))
        }
    }

    // MARK: -- Set Data
    func addData(collectionName: String, data: [String:Any], completion: @escaping (Result<String, Error>) -> ()) {
        self.firestore.collection(collectionName).addDocument(data: data) { err in
            if let err = err {
                completion(.failure(err))
                return
            }
            completion(.success(" ... added new data to cloud."))
        }
    }

    func addDatawithDocumentName(collectionName: String, documentName: String, data: [String:Any], completion: @escaping (Result<String, Error>) -> ()) {
            self.firestore.collection(collectionName).document(documentName).setData(data) { err in
            if let err = err {
                completion(.failure(err))
                return
            }
            completion(.success(" ... added new data to \(collectionName) / \(documentName)"))
        }
    }

}
