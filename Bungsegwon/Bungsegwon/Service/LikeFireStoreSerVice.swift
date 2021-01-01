//
//  LikeFireStoreSerVice.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/26.
//

import Foundation
import FirebaseFirestore

class LikeFireStoreSerVice {
  static func LikeFireStoreSerVice(storeId: String, address: String, mainMenu: String) {
    let db = Firestore.firestore()
    let uid = UserDefaults.standard.value(forKey: "uid") as! String
    let usersRef = db.collection("users")
    let userRef = usersRef.document(uid)
    let likeStores = userRef.collection("liked_stores").document(storeId)
    
    likeStores.getDocument { (document, error) in
      if let isExists = document?.exists {
        print("있음 true, 없음 false : \(isExists)")
        if isExists {
          // 없을 경우 likeStores에서 삭제
          print("like 데이터 있음 - 삭제")
          likeStores.delete() { err in
            if let err = err {
              print("likeStore 삭제 실패 - \(err.localizedDescription)")
            } else {
              print("likeStore 삭제 성공")
            }
          }
        } else {
          // 없을 경우 likeStores에 추가
          likeStores.setData([
            "id": storeId,
            "address": address,
            "timestamp": Int(NSDate.timeIntervalSinceReferenceDate*1000).description,
            "main_menu": mainMenu
          ]) { (error) in
            
            if let error = error {
              // like 데이터 추가하기 실패
              print("like 데이터 추가하기 실패 - ", error.localizedDescription)
            } else {
              // like 데이터 추가하기 성공
              print("like 데이터 추가하기 성공")
            }
          }
        }
      } else {
        print("like데이터 가져오기 실패")
      }
    }
  }
}
