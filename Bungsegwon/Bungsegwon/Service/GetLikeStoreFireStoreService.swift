//
//  GetLikeStoreFireStoreService.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/26.
//

import Foundation
import FirebaseFirestore

class GetLikeStoreFireStoreService {
  static func getLikeData(completionHandler: @escaping (QuerySnapshot?) -> Void) {
    let db = Firestore.firestore()
    let uid = UserDefaults.standard.value(forKey: "uid") as! String
    let user = db.collection("users").document(uid)
    
    // 내림차순으로 최근에 찜한 가게먼저 순서대로 가져옴
    user.collection("liked_stores").order(by: "timestamp").getDocuments { (querySnapshot, error) in
      if let error = error {
        print("user에 like가게 가져오기 실패 - \(error.localizedDescription)")
      } else {
        completionHandler(querySnapshot)
      }
      
    }
  }
}
