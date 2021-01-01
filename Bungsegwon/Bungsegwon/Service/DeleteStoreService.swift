//
//  DeleteStoreService.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/29.
//

import Foundation
import FirebaseFirestore

class DeleteStoreService {
  static func deleteStore(storeId: String) {
    print("서비스 들어옴")
    print(storeId)
    let db = Firestore.firestore()
    let uid = UserDefaults.standard.value(forKey: "uid") as! String
    let storeDoc = db.collection("stores").document(storeId)
//    let storeInfoDoc = db.collection("stores_info").document(storeId)
//    let createdStoresDoc = db.collection("users").document(uid).collection("created_stores")
    
    
    
    storeDoc.delete() { err in
        if let err = err {
          print("내가 등록한 가게 stores 삭제 실패 : \(err.localizedDescription)")
        } else {
            print("내가 등록한 가게 stores 삭제 성공")
          db.collection("stores_info").document(storeId).delete() { err in
              if let err = err {
                print("내가 등록한 가게 stores_info 삭제 실패 : \(err.localizedDescription)")
              } else {
                  print("내가 등록한 가게 stores_info 삭제 성공")
                db.collection("users").document(uid).collection("created_stores").document(storeId).delete { (err) in
                  if let err = err {
                    print("내가 등록한 가게 created_stores 삭제 실패 : \(err.localizedDescription)")
                  } else {
                      print("내가 등록한 가게 created_stores 삭제 성공")
                  }
                }
              }
          }
        }
    }
    
    
  }
}
