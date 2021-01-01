//
//  MainSingUpViewController.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/22.
//

import UIKit

import UIKit
// **** 페이스북
import FBSDKLoginKit
// 페이스북
// **** 파이어베이스
import FirebaseAuth
import FileProvider
import FirebaseFirestore
// 파이어베이스
// **** 구글
import GoogleSignIn
// 구글
// **** 애플
import AuthenticationServices
import CryptoKit
// 애플
protocol MainSingUpViewControllerDelegate {
  func titleImageViewIsHidden() -> Bool
}

class MainSingUpViewController: UIViewController {
  // MARK: - Properties
  private let mainSignUpTopView = MainSignUpTopView()
  private var mainSingUpView = MainSingUpView()
  private var isTitleImageView: Bool?
  private let facebookSignUpService = FacebookSignUpService()
  // 애플 로그인 암호화 스트링
  fileprivate var currentNonce: String?
  var delegate: MainSingUpViewControllerDelegate?
  let indicatorVC = IndicatorViewController()
  // 로그인이 안됐을 때 상품상세에서 로그인 페이지로 넘어왔을 때 로그인이 되면 자신이 찜을 한 상품인지 확인 후에 값을 다시 넘겨줌
  var getData: GetStore?
  
  // MARK: - View LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.setUI()
    self.setLayout()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    self.navigationController?.isNavigationBarHidden = true
    
    self.isTitleImageView = self.delegate?.titleImageViewIsHidden()
    guard let ishidden = self.isTitleImageView else { return }
    self.titleImageViewHidden(ishidden)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
  }
  
  // MARK: - SetUI
  private func setUI() {
    [
      self.mainSingUpView,
      self.mainSignUpTopView
    ].forEach {
      self.view.addSubview($0)
    }
    
    self.view.backgroundColor = .white
    
    self.mainSingUpView.facebookBtn.addTarget(
      self,
      action: #selector(self.facebookDidTapBtn),
      for: .touchUpInside
    )
    
    self.mainSingUpView.googleBtn.addTarget(
      self,
      action: #selector(self.googleDidTapBtn),
      for: .touchUpInside
    )
    GIDSignIn.sharedInstance().delegate = self
    
    self.mainSingUpView.appleBtn.addTarget(
      self,
      action: #selector(self.appleDidTapBtn),
      for: .touchUpInside
    )
    
    self.mainSignUpTopView.dismissBtn.addTarget(
      self,
      action: #selector(self.dismissDidTapBtn),
      for: .touchUpInside
    )
  }
  
  // MARK: - SetLayout
  private func setLayout() {
    self.mainSignUpTopView.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
      $0.leading.trailing.equalToSuperview()
    }
    
    self.mainSingUpView.snp.makeConstraints {
      $0.top.equalTo(self.mainSignUpTopView.snp.bottom)
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
    }
  }
  
  // MARK: - Configure
  private func titleImageViewHidden(_ ishidden: Bool) {
    if ishidden {
      UIView.animate(withDuration: 1, delay: 3) {
        
        self.mainSingUpView.titleImageView.alpha = 0
      }
      self.mainSingUpView.layoutIfNeeded()
    } else {
      self.mainSingUpView.titleImageView.isHidden = true
    }
  }
  
  // MARK: - Action Button
  // 페이스북 로그인
  @objc private func facebookDidTapBtn(_ sender: UIButton) {
    facebookSignUpService.facebookSignUpService(
      viewController: self) { (token) in
      
      let credential = FacebookAuthProvider.credential(
        withAccessToken: token.tokenString
      )
      self.firebaseAuth(credential)
    }
  }
  
  @objc private func googleDidTapBtn(_ sender: UIButton) {
    GIDSignIn.sharedInstance()?.presentingViewController = self
    GIDSignIn.sharedInstance().signIn()
  }
  
  @objc private func appleDidTapBtn(_ sender: UIButton) {
    self.startSignInWithAppleFlow()
  }
  
  @objc private func dismissDidTapBtn(_ sender: UIButton) {
    self.dismiss(animated: true, completion: nil)
  }
  
  
  func firebaseAuth(_ credential: AuthCredential) {
    self.indicatorVC.modalPresentationStyle = .overFullScreen
    self.present(self.indicatorVC, animated: false, completion: {
      
    })
    
    Auth.auth().signIn(with: credential) { (authResult, error) in
      guard let user = Auth.auth().currentUser else {
        return print("로그인 되어 있지 않아 정보를 받을 수가 없음 - MainSingUpViewController")
      }
      guard let userEmail = user.email else {
        return print("로그인은 성공했지만 유저의 email이 없음")
      }
      guard let userProvider = user.providerData.first?.providerID else {
        return print("로그인은 성공했지만 유저의 제공업체를 받아오지 못함")
      }
      let userUid = user.uid
      print(userEmail, userProvider, userUid)
      
      self.checkUid(uid: userUid, email: userEmail, provider: userProvider)
    }
  }
  
  // 가입을 했는지 안했는지 확인 후 nickName을 설정할지 안할지 결정하는 함수
  private func checkUid(uid: String, email: String, provider: String) {
    CheckFirestoreService.checkUidService(uid: uid) { (result) in
      switch result {
      case .success(let isEmpty):
        if isEmpty {
          
          self.indicatorVC.isDismiss = true
          
          self.nickNamePresent(uid: uid, email: email, provider: provider)
        } else {
          
          print("nickName 있음 ------ 있으니까 dismiss")
          let db = Firestore.firestore()
          let docRef = db.collection("users").document(uid)
          
          docRef.getDocument { (document, error) in
            if let document = document, document.exists {
              guard let dataDescription = document.data() as? [String: String] else { return }
              let getNickName = dataDescription["name"]!
              let getEmail = dataDescription["email"]!
              let getProviders = dataDescription["provider"]!
              
              self.existingUserPresent(
                uid: uid,
                email: getEmail,
                provider: getProviders,
                nickName: getNickName
              )
            } else {
              print("Document does not exist")
            }
          }
        }
      case .failure(let error):
        print(error.localizedDescription, "파이어스토어 유저정보 가져오기 오류")
      }
    }
  }
  
  private func existingUserPresent(uid: String, email: String, provider: String, nickName: String) {
    // 아래의 것들 네트워크 처리하고 데이터에 uid에 닉네임 가져오고 completion에 넣어주기
    // 로그인을 했었던 유저 정보 업로드
    UserDefaults.standard.setValue(uid, forKey: "uid")
    UserDefaults.standard.setValue(email, forKey: "email")
    UserDefaults.standard.setValue(provider, forKey: "provider")
    UserDefaults.standard.setValue(nickName, forKey: "nickName")
    UserDefaults.standard.setValue(true, forKey: "isLogin")
    
    GetLikeStoreFireStoreService.getLikeData { (querySnapshot) in
      guard let querySnapshot = querySnapshot else {
        return print("like에서 가져온 값이 잘못됨 - LaunchViewController")
      }
      
      self.dataAppend(querySnapshot: querySnapshot)
      
      GetCreatedStroeService.getCreatedStroe { (querySnapshot) in
        guard let querySnapshot = querySnapshot else {
          return print("내가 등록한 가게에서 가져온 값이 잘못됨 - LaunchViewController")
        }
        
        self.createdStoreAppend(querySnapshot: querySnapshot)
        
        // 내가 쓴 댓글
        GetMyCommentFireStoreService.getMyComment { (querySnapshot) in
          guard let query = querySnapshot else { return }
          
          for doc in query.documents {
            let data = doc.data()
            let comment = data["comment"] as! String
            let id = data["id"] as! String
            let mainMenu = data["main_menu"] as! String
            let createdDate = data["created_at"] as! String
            let myComment = MyComment(
              id: id,
              comment: comment,
              mainMenu: mainMenu,
              createdDate: createdDate
            )
            
            StoreShared.shared.myComments.insert(myComment, at: 0)
          }
          self.indicatorVC.isDismiss = true
          
          let presentingVC = self.presentingViewController
          self.dismiss(animated: true, completion: {
            // 리로드 시키는 함수 ex) 로그인을 다시 했을 때 데이터를 가져와야 함
            self.reloadVC(presentingVC: presentingVC)
          })
        }
        
        print("---------찜, 내가 등록한 가게 데이터 가져 옴----------")
      }
    }
  }
  
  // 나를 부른 ViewController 찾은 후 리턴
  private func reloadVC(presentingVC: UIViewController?) {
    guard let tabTC = presentingVC as? MainTabBarController,
          let navi = tabTC.selectedViewController as? UINavigationController else {
      return print("나를 부른 컨트롤러가 잘못됨 - ")
    }
    let vcs = navi.viewControllers
    
    for vc in vcs {
      if let storePageVC = vc as? StorePageViewController {
        
        storePageVC.reloadVC()
        
      } else if let _ = vc as? MyPageViewController {
        NotificationCenter.default.post(
          name: NSNotification.Name("ReloadVC"),
          object: nil
        )
      }
    }
       
  }
  
//  private func checkStoreLike(storeId: String) -> Bool {
//    for i in 0 ..< StoreShared.shared.getStores.count {
//      if StoreShared.shared.getStores[i].id == storeId {
//        StoreShared.shared.getStores[i].isLike = true
//        break
//      }
//    }
//
//    for i in 0 ..< StoreShared.shared.likeStore.count {
//      if StoreShared.shared.likeStore[i].id == storeId {
//        return true
//      }
//    }
//
//    return false
//  }
  
  private func createdStoreAppend(querySnapshot: QuerySnapshot) {
    for document in querySnapshot.documents {
      let data = document.data()
      let address = data["address"] as! String
      let id = data["id"] as! String
      let mainMenu = data["main_menu"] as! String
      let createdStore = CreatedStore(
        id: id,
        address: address,
        mainMenu: mainMenu
      )
      
      StoreShared.shared.createdStores.insert(createdStore, at: 0)
    }
  }
  
  // 받아온 데이터를 StoreShared.shared.likeStore에 저장
  private func dataAppend(querySnapshot: QuerySnapshot) {
    for document in querySnapshot.documents {
      let data = document.data()
      let likeStore = LikeStore(
        id: data["id"] as! String,
        address: data["address"] as! String,
        mainMenu: data["main_menu"] as! String
      )
      
      StoreShared.shared.likeStore.insert(likeStore, at: 0)
    }
  }
  
  private func nickNamePresent(uid: String, email: String, provider: String) {
    let nickNameVC = NicknameSettingViewController()
    
    nickNameVC.modalPresentationStyle = .fullScreen
    nickNameVC.userUidStr = uid
    nickNameVC.userProviderStr = provider
    nickNameVC.userEmailStr = email
    
    self.present(nickNameVC, animated: true, completion: nil)
  }
  
  deinit {
    print("deinit MainSingUpVC")
  }
}

// MARK: - Extension

// MARK: - GIDSignInDelegate Extension 구글
extension MainSingUpViewController: GIDSignInDelegate {
  func sign(_ signIn: GIDSignIn!,
            didSignInFor user: GIDGoogleUser!,
            withError error: Error!) {
    
    // Check for sign in error
    if let error = error {
      if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
        print("The user has not signed in before or they have since signed out.")
      } else {
        print("구글 로그인 Error : \(error.localizedDescription)")
      }
      return
    }
    guard let authentication = user.authentication else {
      return print("구글 로그인 authentication를 못받아 옴 - MainSingUpViewController")
    }
    let credential = GoogleAuthProvider.credential(
      withIDToken: authentication.idToken,
      accessToken: authentication.accessToken
    )
    self.firebaseAuth(credential)
  }
}


// MARK: - ASAuthorizationControllerDelegate Extension 애플
extension MainSingUpViewController: ASAuthorizationControllerDelegate {
  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
      guard let nonce = currentNonce else {
        fatalError("애플 로그인 콜백이 수신되었지만 로그인 요청이 전송되지 않았습니다.")
      }
      guard let appleIDToken = appleIDCredential.identityToken else {
        print("Unable to fetch identity token")
        return
      }
      guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
        print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
        return
      }
      // Initialize a Firebase credential.
      let credential = OAuthProvider.credential(
        withProviderID: "apple.com",
        idToken: idTokenString,
        rawNonce: nonce
      )
      // Sign in with Firebase.
      self.firebaseAuth(credential)
    }
  }
  
  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    print("애플 로그인 : ", error)
  }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding Extension 애플
extension MainSingUpViewController:
  ASAuthorizationControllerPresentationContextProviding {
  func presentationAnchor(
    for controller: ASAuthorizationController
  ) -> ASPresentationAnchor {
    return self.view.window!
  }
}

// MARK: - 애플 로그인 필요한 함수들
extension MainSingUpViewController {
  // 애플 암호화 생성
  private func randomNonceString(length: Int = 32) -> String {
    precondition(length > 0)
    let charset: Array<Character> =
      Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
    var result = ""
    var remainingLength = length
    
    while remainingLength > 0 {
      let randoms: [UInt8] = (0 ..< 16).map { _ in
        var random: UInt8 = 0
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
        if errorCode != errSecSuccess {
          fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
        }
        return random
      }
      
      randoms.forEach { random in
        if remainingLength == 0 {
          return
        }
        
        if random < charset.count {
          result.append(charset[Int(random)])
          remainingLength -= 1
        }
      }
    }
    
    return result
  }
  
  func startSignInWithAppleFlow() {
    let nonce = self.randomNonceString()
    self.currentNonce = nonce
    
    let appleIDProvider = ASAuthorizationAppleIDProvider()
    let request = appleIDProvider.createRequest()
    request.requestedScopes = [.fullName, .email]
    request.nonce = self.sha256(nonce)
    
    let authorizationController = ASAuthorizationController(authorizationRequests: [request])
    authorizationController.delegate = self
    authorizationController.presentationContextProvider = self
    authorizationController.performRequests()
  }
  
  private func sha256(_ input: String) -> String {
    let inputData = Data(input.utf8)
    let hashedData = SHA256.hash(data: inputData)
    let hashString = hashedData.compactMap {
      return String(format: "%02x", $0)
    }.joined()
    
    return hashString
  }
}
