//
//  GetMapsFireStoreService.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/26.
//

import Foundation
import FirebaseFirestore

class GetMapsFireStoreService {
  static func getMaps(completionHandler: @escaping (QuerySnapshot?) -> Void) {
    let db = Firestore.firestore()
    db.collection("stores_info").getDocuments() { (querySnapshot, err) in
      if let err = err {
        
        print("Error getting documents: \(err)")
      } else {
        completionHandler(querySnapshot)
      }
    }
  }
}
