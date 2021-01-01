//
//  FacebookSignUpService.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/22.
//

import FBSDKLoginKit
import Firebase

protocol FacebookSignUpProtocol {
  func facebookSignUpService(
    viewController: UIViewController,
    completionHandler: @escaping (AccessToken) -> Void
  )
}

class FacebookSignUpService: FacebookSignUpProtocol {
  func facebookSignUpService(viewController: UIViewController, completionHandler: @escaping (AccessToken) -> Void
  ) {
    let loginManager = LoginManager()
    
    if let _ = AccessToken.current {
      // 로그아웃
      print("페이스북 로그아웃")
      do {
                  try Auth.auth().signOut()
                } catch let signOutError as NSError {
                  print ("Error signing out: %@", signOutError)
                }
      loginManager.logOut()
    } else {
      // 로그인
      print("페이스북 로그인")
      loginManager.logIn(
        permissions: [.email],
        viewController: viewController
      ) { (result) in
        
        switch result {
        case .failed(let error):
          print("페이스북 result 첫 번째 Error : ", error.localizedDescription)
        case .cancelled:
          print("사용자에 의해 취소 됨")
        case .success(
          granted: _,
          declined: _,
          token: let token
        ):
          completionHandler(token)
          print("페이스북 토큰 : ", token.tokenString)
        }
      }
    }
  }
}


