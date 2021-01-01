//
//  DeleteLikeStoreService.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/28.
//

import Foundation
import FirebaseFirestore

class DeleteLikeStoreService {
  static func deleteLike(storeId: String) {
    let db = Firestore.firestore()
    let uid = UserDefaults.standard.value(forKey: "uid") as! String
    let user = db.collection("users").document(uid)
    
    user.collection("liked_stores").document(storeId).delete() { err in
        if let err = err {
          print("내가 찜한 가게 삭제 실패 : \(err.localizedDescription)")
        } else {
            print("내가 찜한 가게 삭제 성공")
        }
    }
  }
}
