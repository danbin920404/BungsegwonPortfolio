//
//  NicknameSettingViewController.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/22.
//

import UIKit
import FirebaseFirestore

class NicknameSettingViewController: UIViewController {
  // MARK: - Properties
  private let db = Firestore.firestore()
  private let nicknameSettingView = NicknameSettingView()
  var userUidStr = ""
  var userProviderStr = ""
  var userEmailStr = ""
  var isNickName = true
  
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
  
  // 키보드 올라 온 후 뷰를 터치하면 내려가는 기능
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
    
    self.view.endEditing(true)
  }
  
  // MARK: - SetUI
  private func setUI() {
    self.view.addSubview(self.nicknameSettingView)
    
    self.view.backgroundColor = .white
    
    self.nicknameSettingView.completedBtn.addTarget(
      self,
      action: #selector(self.completedDidTapBtn),
      for: .touchUpInside
    )
    
    self.nicknameSettingView.nickNameTextField.delegate = self
  }
  
  // MARK: - SetLayout
  private func setLayout() {
    self.nicknameSettingView.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  // MARK: - Action Button
  @objc private func completedDidTapBtn(_ sender: UIButton) {
    guard let nickName = self.nicknameSettingView.nickNameTextField.text else {
      return print("nickName 텍스트필드에 텍스트가 없음")
    }
    // 닉네임이 있는지 없는지 여부 판단해서 다음과 같이 함수 실행
    if nickName.isEmpty {
      
      self.checkTextField()
    } else {
      CheckFirestoreService.checkNickNameService(nickName: nickName) { (result) in
        switch result {
        case .success(let isEmpty):
          if isEmpty {
            
            self.dbSetData(nickName: nickName)
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
    let usersRef = db.collection("users")
    
    usersRef.document(self.userUidStr).setData([
      "name": nickName,
      "email": self.userEmailStr,
      "provider": self.userProviderStr,
      "uid": self.userUidStr
    ]) { _ in
//      let userRef = usersRef.document(self.userUidStr)
//      let liked_stores = userRef.collection("liked_stores")
//      let created_stores = userRef.collection("created_stores")
//      let my_comments = userRef.collection("my_comments")
//
//      [
//        liked_stores,
//        created_stores,
//        my_comments
//      ].forEach {
//        if $0 == my_comments {
//          my_comments.addDocument(
//            data: [
//              "id": "",
//              "text": "",
//              "created_at": ""
//            ]
//          ) { (error) in
//            if let error = error {
//                print("Error updating document: \(error)")
//            } else {
//                print("Document successfully updated")
//              print("성공")
//            }
//          }
//
//          return
//        }
//
//        $0.addDocument(
//          data: [
//            "id": "",
//            "created_at": ""
//          ]
//        ) { (error) in
//          if let error = error {
//              print("Error updating document: \(error)")
//          } else {
//              print("Document successfully updated")
//            print("성공")
//          }
//        }
//      }
//      liked_stores.addDocument(
//        data: [
//          "id": "내가좋아하는가게",
//          "created_at": "2020.12.20"
//        ]
//      ) { (error) in
//        if let error = error {
//            print("Error updating document: \(error)")
//        } else {
//            print("Document successfully updated")
//          print("성공")
//        }
//      }
//
//      created_stores.addDocument(
//        data: [
//          "id": "단빈가게",
//          "created_at": "2020.12.20"
//        ]
//      ) { (error) in
//        if let error = error {
//            print("Error updating document: \(error)")
//        } else {
//            print("Document successfully updated")
//          print("성공")
//        }
//      }
  
      UserDefaults.standard.setValue(self.userUidStr, forKey: "uid")
      UserDefaults.standard.setValue(self.userEmailStr, forKey: "email")
      UserDefaults.standard.setValue(self.userProviderStr, forKey: "provider")
      UserDefaults.standard.setValue(nickName, forKey: "nickName")
      UserDefaults.standard.setValue(true, forKey: "isLogin")
      
      UIApplication.shared.windows.first?
        .rootViewController?.dismiss(animated: true, completion: nil)
    }
    
  }
  
  private func checkTextField() {
    let redPlaceholderText = NSAttributedString(
      string: "멋진 이름을 지어주세요.",
      attributes: [NSAttributedString.Key.foregroundColor: UIColor.red]
    )
    
    self.nicknameSettingView.nickNameTextField.layer.borderColor = UIColor.red.cgColor
    self.nicknameSettingView.nickNameTextField.attributedPlaceholder = redPlaceholderText
  }
  
  // 다른 사람이 닉네임을 사용한다면 다시 닉네임 설정
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
  
  deinit {
    print("사라짐")
  }
}

// MARK: - Extension
extension NicknameSettingViewController: UITextFieldDelegate {
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
