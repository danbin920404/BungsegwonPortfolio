//
//  EditMyInfoViewController.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/22.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import FBSDKLoginKit

class EditMyInfoViewController: UIViewController {
  // MARK: - Properties
  private let topNavigationContainerView = UIView()
  private let topNavigationView = TopNavigationView(
    frame: .zero,
    isLeftAndRightBtn: true,
    titleStr: "내 정보 수정"
  )
  private let editMyInfoView = EditMyInfoView()
  
  
  // MARK: - View LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.setUI()
    self.setLayout()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    self.navigationController?.isNavigationBarHidden = true
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
    
    self.view.endEditing(true)
  }
  
  // MARK: - SetUI
  private func setUI() {
    [
      self.editMyInfoView,
      self.topNavigationContainerView
    ].forEach {
      self.view.addSubview($0)
    }
    
    self.topNavigationContainerView.addSubview(self.topNavigationView)
    self.topNavigationContainerView.backgroundColor = .systemGray6
    
    self.view.backgroundColor = .white
    
    self.editMyInfoView.delegate = self
    
    self.setUserInfoLabelText()
    
    self.topNavigationView.leftDismissBtn.addTarget(
      self,
      action: #selector(self.dismissDidTapBtn),
      for: .touchUpInside
    )
    
    self.editMyInfoView.nickNameTextField.delegate = self
  }
  
  // MARK: - SetLayout
  private func setLayout() {
    self.topNavigationContainerView.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
      $0.leading.trailing.equalToSuperview()
    }
    
    self.topNavigationView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalToSuperview()
    }
    
    self.editMyInfoView.snp.makeConstraints {
      $0.top.equalTo(self.topNavigationView.snp.bottom)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  private func setUserInfoLabelText() {
    guard let nickNameStr = UserDefaults.standard.value(forKey: "nickName") as? String else {
      return print("유저디폴트에 닉네임이 없음 - EditMyInfoViewController")
    }
    
    guard let emailStr = UserDefaults.standard.value(forKey: "email") as? String else {
      return print("유저디폴트에 이메일이 없음 - EditMyInfoViewController")
    }
    
    guard let providerStr = UserDefaults.standard.value(forKey: "provider") as? String else {
      return print("유저디폴트에 로그인 회사가 없음 - EditMyInfoViewController")
    }
    
    self.editMyInfoView.setUserInfo(
      nickName: nickNameStr,
      email: emailStr,
      provider: providerStr
    )
  }
  
  // MARK: - Action Button
  @objc private func dismissDidTapBtn(_ sender: UIButton) {
    
    self.navigationController?.popViewController(animated: true)
  }
}

// MARK: - Extension
extension EditMyInfoViewController: EditMyInfoViewDelegate {
  func withdrawalDidTapBtn() {
    
    self.secessionAlertPresent()
  }
  
  func logoutDidTapBtn() {
    print("로그아웃 버튼 누름 ------------------------------------- EditMyInfoViewController")
    // 페이스북 로그아웃은 페이스북도 로그아웃을 해줘야 한다
    guard let provider = UserDefaults.standard.value(forKey: "provider") as? String else {
      return print("provider가 없음 - EditMyInfoViewController")
    }
    
    if provider == "facebook.com" {
      let loginManager = LoginManager()
      loginManager.logOut()
    }
    
    let firebaseAuth = Auth.auth()
    do {
      try firebaseAuth.signOut()
      UserDefaults.standard.setValue(false, forKey: "isLogin")
      self.getStoresReset()
      StoreShared.shared.likeStore = []
      StoreShared.shared.createdStores = []
      StoreShared.shared.myComments = []
      self.navigationController?.popViewController(animated: false)
      print("로그아웃 완료 ------------------------------------- EditMyInfoViewController")
    } catch let signOutError as NSError {
      print ("Error signing out: %@", signOutError, "- EditMyInfoViewController")
    }
  }
  
  // StoreShared.shared.getStores에 isLike를 리셋시키기
  private func getStoresReset() {
    for i in 0 ..< StoreShared.shared.getStores.count {
      StoreShared.shared.getStores[i].isLike = false
    }
  }
  
  func completedDidTapBtn() {
    let newNickName = editMyInfoView.getNickName()
    
    if newNickName.isEmpty {
      
      self.checkTextField()
    } else {
      CheckFirestoreService.checkNickNameService(nickName: newNickName) { (result) in
        switch result {
        case .success(let isEmpty):
          if isEmpty {
            
            print("중복 아님")
            self.dbSetData(nickName: newNickName)
          } else {
            
            self.alertPresent()
          }
        case .failure(let error):
          print(error.localizedDescription)
        }
      }
    }
  }
  
  // 다른 사람이 닉네임을 사용하고 있지 않다면 파이어스토어에 저장
  private func dbSetData(nickName: String) {
    guard let uid = UserDefaults.standard.value(forKey: "uid") as? String else { return }
    let db = Firestore.firestore()
    let usersRef = db.collection("users").document(uid)
    
    usersRef.updateData(
      
      ["name": nickName])
    { (error) in
      if let error = error {
        print("Error updating document: \(error) - EditMyInfoViewController")
      } else {
        print("Document successfully updated 성공")
        UserDefaults.standard.setValue(nickName, forKey: "nickName")
        
        //        UIApplication.shared.windows.first?
        //          .rootViewController?.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
      }
    }
  }
  
  private func checkTextField() {
    let redPlaceholderText = NSAttributedString(
      string: "멋진 이름을 지어주세요.",
      attributes: [NSAttributedString.Key.foregroundColor: UIColor.red]
    )
    
    self.editMyInfoView.nickNameTextField.layer.borderColor = UIColor.red.cgColor
    self.editMyInfoView.nickNameTextField.attributedPlaceholder = redPlaceholderText
  }
  
  private func alertPresent() {
    let alert = UIAlertController(
      title: "닉네임 중복",
      message: "사용할 수 없는 이름입니다.\n다른 이름을 사용하세요.",
      preferredStyle: .alert
    )
    let alertAction = UIAlertAction(
      title: "확인",
      style: .cancel,
      handler: nil
    )
    
    alert.addAction(alertAction)
    
    self.present(alert, animated: true, completion: nil)
  }
  
  private func secessionAlertPresent() {
    let alert = UIAlertController(
      title: "회원탈퇴",
      message: "탈퇴하시겠습니까?",
      preferredStyle: .alert
    )
    let defaultAction = UIAlertAction(
      title: "아니요",
      style: .default,
      handler: nil
    )
    let destructiveAction = UIAlertAction(
      title: "예",
      style: .destructive,
      handler: { _ in
        let indiVC = IndicatorViewController()
        indiVC.modalPresentationStyle = .overFullScreen
        self.present(indiVC, animated: false, completion: nil)
        guard let user = Auth.auth().currentUser else { return }
        user.delete { error in
          if let error = error {
            print("회원탈퇴 error : ", error.localizedDescription)
          } else {
            let db = Firestore.firestore()
            db.collection("users").document(user.uid).delete() { err in
              if let err = err {
                
                print("Error removing document: \(err)")
              } else {
                
                print("회원탈퇴 성공")
                indiVC.isDismiss = true
                UserDefaults.standard.setValue(false, forKey: "isLogin")
                self.getStoresReset()
                StoreShared.shared.likeStore = []
                StoreShared.shared.createdStores = []
                StoreShared.shared.myComments = []
                self.navigationController?.popViewController(animated: false)
              }
            }
          }
        }
      })
    alert.addAction(destructiveAction)
    alert.addAction(defaultAction)
    
    self.present(alert, animated: true, completion: nil)
  }
}

extension EditMyInfoViewController: UITextFieldDelegate {
  func textFieldDidChangeSelection(_ textField: UITextField) {
    guard let text = textField.text else { return }
    
    if !text.isEmpty {
      let redPlaceholderText = NSAttributedString(
        string: "멋진 이름을 지어주세요.",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor(
          red: 0.769,
          green: 0.769,
          blue: 0.769,
          alpha: 1
        )]
      )
      
      textField.layer.borderColor = UIColor(
        red: 0.898,
        green: 0.898,
        blue: 0.898,
        alpha: 1
      ).cgColor
      textField.attributedPlaceholder = redPlaceholderText
    }
  }
}
