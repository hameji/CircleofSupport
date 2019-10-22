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
    
    // MARK: -- CRUD ( Create/Read/Update/Delete )
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
    
    func addData(collectionName: String, data: [String:Any], completion: @escaping (Result<String, Error>) -> ()) {
        self.firestore.collection(collectionName).addDocument(data: data) { err in
            if let err = err {
                completion(.failure(err))
                return
            }
            completion(.success(" ... added new data to cloud."))
        }
    }
    
}
