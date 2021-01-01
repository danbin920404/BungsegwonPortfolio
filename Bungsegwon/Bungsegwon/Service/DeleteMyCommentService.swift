//
//  DeleteMyCommentService.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/28.
//

import Foundation
import FirebaseFirestore

class DeleteMyCommentService {
  static func deleteMyCommnet(storeId: String, comment: String) {
    let db = Firestore.firestore()
    let uid = UserDefaults.standard.value(forKey: "uid") as! String
    let user = db.collection("users").document(uid)
    let myComment = user.collection("my_comments")
    
    myComment.whereField("id", isEqualTo: storeId).whereField("comment", isEqualTo: comment)
      .getDocuments { (querySnapshot, err) in
        if let err = err {
          print("Error getting documents: \(err)")
        } else {
          
          for document in querySnapshot!.documents {
            myComment.document(document.documentID).delete() { err in
                if let err = err {
                  print("내가 쓴 댓글 삭제 실패 : \(err.localizedDescription)")
                } else {
                    print("내가 쓴 댓글 삭제 성공")
                }
            }
          }
        }
    }
    
    let comments = db.collection("comments")
    let commentsDoc = comments.document(storeId)
    let commentRef = commentsDoc.collection("comment")
    
    commentRef.whereField("comment", isEqualTo: comment)
      .whereField("id", isEqualTo: storeId)
      .getDocuments { (querySnapshot, err) in
        if let err = err {
          print("Error getting documents: \(err)")
        } else {
          for document in querySnapshot!.documents {
            commentRef.document(document.documentID).delete() { err in
                if let err = err {
                  print("상세 페이지 댓글 데이터 삭제 실패 : \(err.localizedDescription)")
                } else {
                    print("상세 페이지 댓글 데이터 삭제 성공")
                }
            }
          }
        }
      }
  }
  
  
}
