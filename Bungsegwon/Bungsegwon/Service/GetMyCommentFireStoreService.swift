//
//  ModifyStoreFireStoreService.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/28.
//

import Foundation
import FirebaseFirestore

class GetMyCommentFireStoreService {
  static func getMyComment(completionHandler: @escaping (QuerySnapshot?) -> Void) {
    guard let uid = UserDefaults.standard.value(forKey: "uid") as? String else {
      return print("유저디폴트에 닉네임이 없음 - MyPageViewController")
    }
    let db = Firestore.firestore()
    let users = db.collection("users")
    let myComments = users.document(uid).collection("my_comments")
    
    myComments.order(by: "timestamp").getDocuments { (querySnapshot, error) in
      if let error = error {
        print("내가 쓴 댓글 가져오기 실패 : \(error)")
      }
      
      completionHandler(querySnapshot)
    }
    
  }
}
