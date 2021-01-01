//
//  CreatedCommentFireStoreService.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/26.
//

import Foundation
import FirebaseFirestore

class CreatedCommentFireStoreService {
  static func createdComment(storeId: String, comment: String, mainMenu: String) {
    let uid = UserDefaults.standard.value(forKey: "uid") as! String
    let nickName = UserDefaults.standard.value(forKey: "nickName") as! String
    let timestamp = Int(NSDate.timeIntervalSinceReferenceDate*1000).description
    
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.dateFormat = "yyyy.MM.dd"
    let nowDateStr = formatter.string(from: Date())
    
    let db = Firestore.firestore()
    let commentsRef = db.collection("comments").document(storeId)
    let commentRef = commentsRef.collection("comment")
    
    commentRef.addDocument(data: [
      "id": storeId,
      "uid": uid,
      "name": nickName,
      "comment": comment,
      "created_at": nowDateStr,
      "timestamp": timestamp
    ]) { (error) in
      if let error = error {
        print("댓글 추가 실패 : ", error.localizedDescription)
      } else {
        print("댓글 추가 성공")
        let userDoc = db.collection("users").document(uid)
        let myComments = userDoc.collection("my_comments")
        
        myComments.addDocument(data: [
          "id": storeId,
          "created_at": nowDateStr,
          "comment": comment,
          "main_menu": mainMenu,
          "timestamp": timestamp
        ]) { (error) in
          if let error = error {
            print("나의댓글 추가 실패 : ", error.localizedDescription)
          } else {
            print("나의댓글 추가 성공")
            let myComment = MyComment(
              id: storeId,
              comment: comment,
              mainMenu: mainMenu,
              createdDate: nowDateStr
            )
            
            StoreShared.shared.myComments.insert(myComment, at: 0)
          }
        }
      }
    }
  }
}
