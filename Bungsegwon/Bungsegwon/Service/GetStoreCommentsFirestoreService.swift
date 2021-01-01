//
//  GetStoreCommentsFirestoreService.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/26.
//

import Foundation
import FirebaseFirestore

class GetStoreCommentsFirestoreService {
  static func getCommentsData(storeId: String, completionHandler: @escaping (QuerySnapshot?) -> Void) {
    let db = Firestore.firestore()
//    let uid = UserDefaults.standard.value(forKey: "uid") as! String
    let commentsRef = db.collection("comments").document(storeId)
    let commentRef = commentsRef.collection("comment")
    
    // 오름차순으로 예전 댓글 순서대로 가져옴
    commentRef.order(by: "timestamp", descending: false).getDocuments { (querySnapshot, error) in
      if let error = error {
        print("user에 like가게 가져오기 실패 - \(error.localizedDescription)")
      } else {
        completionHandler(querySnapshot)
      }
    }
  }
}
