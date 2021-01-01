//
//  GetCreatedStroeService.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/28.
//

import Foundation
import FirebaseFirestore

class GetCreatedStroeService {
  static func getCreatedStroe(completionHandler: @escaping (QuerySnapshot?) -> Void) {
    let db = Firestore.firestore()
    guard let uid = UserDefaults.standard.value(forKey: "uid") as? String else {
      return print("유저디폴트에 닉네임이 없음 - MyPageViewController")
    }
    let users = db.collection("users")
    let createdStores = users.document(uid).collection("created_stores")
    
    createdStores.order(by: "timestamp").getDocuments { (querySnapshot, err) in
      completionHandler(querySnapshot)
    }
  }
}

