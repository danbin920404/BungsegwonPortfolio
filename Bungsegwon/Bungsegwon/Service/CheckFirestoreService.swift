//
//  CheckFirestoreService.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/22.
//

import FirebaseFirestore

class CheckFirestoreService {
  static func checkNickNameService(nickName: String, completionHandler: @escaping (Result<Bool, Error>) -> Void)  {
    let db = Firestore.firestore()
    let usersRef = db.collection("users")
    
    usersRef.whereField("name", isEqualTo: nickName).getDocuments { (querySnapshot, error) in
      guard error == nil else { return completionHandler(.failure(error!)) }
      
      // MARK: - 결과가 true면 회원가입 허용 false면 닉네임 다시 설정
      do {
        completionHandler(.success(querySnapshot!.isEmpty))
      }
    }
  }
  
  static func checkUidService(uid: String, completionHandler: @escaping (Result<Bool, Error>) -> Void)  {
    let db = Firestore.firestore()
    let usersRef = db.collection("users")
    
    usersRef.whereField("uid", isEqualTo: uid).getDocuments { (querySnapshot, error) in
      guard error == nil else { return completionHandler(.failure(error!)) }
      
      // MARK: - 결과가 true면 회원가입 허용 false면 닉네임 다시 설정
      do {
        completionHandler(.success(querySnapshot!.isEmpty))
      }
    }
  }
}
