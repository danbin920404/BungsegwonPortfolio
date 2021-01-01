//
//  EditMyInfoView.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/22.
//

import UIKit

protocol EditMyInfoViewDelegate {
  func withdrawalDidTapBtn() -> Void
  func logoutDidTapBtn() -> Void
  func completedDidTapBtn() -> Void
}

class EditMyInfoView: UIView {
  // MARK: - Properties
  private let nickNameTitleLabel = UILabel()
  let nickNameTextField = UITextField()
  private let emailTitleLabel = UILabel()
  private let providerImageView = UIImageView()
  private let emailLabel = UILabel()
  private let completedBtn = UIButton()
  private let logoutBtn = UIButton()
  private let withdrawalBtn = UIButton()
  private let lineView = UIView()
  var delegate: EditMyInfoViewDelegate?
  
  // MARK: - View LifeCycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.setUI()
    self.setLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    self.nickNameTextField.layer.cornerRadius = 8
    self.nickNameTextField.layer.borderWidth = 1
    self.nickNameTextField.layer.borderColor = UIColor(
      red: 0.898,
      green: 0.898,
      blue: 0.898,
      alpha: 1
    ).cgColor
    
    self.completedBtn.layer.cornerRadius = 8
    self.completedBtn.layer.borderWidth = 1
    self.completedBtn.layer.borderColor = UIColor(
      red: 1,
      green: 0.831,
      blue: 0.392,
      alpha: 1
    ).cgColor
    self.completedBtn.layer.shadowColor = UIColor(
      red: 0,
      green: 0,
      blue: 0,
      alpha: 0.12
    ).cgColor // 색깔
    self.completedBtn.layer.shadowOffset = CGSize(width: 0, height: 1) // 위치조정
    self.completedBtn.layer.shadowRadius = 6 // 반경
    self.completedBtn.layer.shadowOpacity = 1 // alpha값
    
//    self.underLine()
  }
  
  // MARK: - SetUI
  private func setUI() {
    [
      self.nickNameTitleLabel,
      self.nickNameTextField,
      self.emailTitleLabel,
      self.providerImageView,
      self.emailLabel,
      self.logoutBtn,
      self.lineView,
      self.withdrawalBtn,
      self.completedBtn
    ].forEach {
      self.addSubview($0)
    }
    
    self.backgroundColor = UIColor(
      red: 0.963,
      green: 0.963,
      blue: 0.963,
      alpha: 1
    )
    
    self.nickNameTitleLabel.text = "닉네임"
    self.nickNameTitleLabel.textColor = .black
    self.nickNameTitleLabel.font = UIFont(
      name: "AppleSDGothicNeo-Bold",
      size: 16
    )
    
    let leftPaddigView = UIView(frame: CGRect(x: 0, y: 0, width: 17, height: 52))
    self.nickNameTextField.leftView = leftPaddigView
    self.nickNameTextField.leftViewMode = .always
    self.nickNameTextField.textColor = .black
    self.nickNameTextField.font = UIFont(
      name: "AppleSDGothicNeo-Bold",
      size: 14
    )
    self.nickNameTextField.backgroundColor = .white
    
    self.emailTitleLabel.text = "이메일"
    self.emailTitleLabel.textColor = .black
    self.emailTitleLabel.font = UIFont(
      name: "AppleSDGothicNeo-Bold",
      size: 16
    )
    
    self.emailLabel.textColor = UIColor(
      red: 0.345,
      green: 0.345,
      blue: 0.345,
      alpha: 1
    )
    self.emailLabel.font = UIFont(
      name: "AppleSDGothicNeo-Regular",
      size: 14
    )
    
    self.completedBtn.setTitle("확인", for: .normal)
    self.completedBtn.titleLabel?.font = UIFont(
      name: "AppleSDGothicNeo-Bold",
      size: 14
    )
    self.completedBtn.setTitleColor(
      .black,
      for: .normal
    )
    self.completedBtn.backgroundColor = UIColor(
      red: 1,
      green: 0.831,
      blue: 0.392,
      alpha: 1
    )
    
    self.lineView.backgroundColor = UIColor(
      red: 0.769,
      green: 0.769,
      blue: 0.769,
      alpha: 1
    )
    
    self.logoutBtn.setImage(UIImage(named: "logoutImage"), for: .normal)
    self.logoutBtn.addTarget(
      self,
      action: #selector(self.logoutBtnDidTap),
      for: .touchUpInside
    )
    
    self.withdrawalBtn.setImage(UIImage(named: "withdrawalImage"), for: .normal)
    self.withdrawalBtn.addTarget(
      self,
      action: #selector(self.withdrawalBtnDidTap),
      for: .touchUpInside
    )
    
    self.completedBtn.addTarget(
      self,
      action: #selector(self.completedBtnDidTap),
      for: .touchUpInside
    )
  }
  
  // MARK: - SetLayout
  private func setLayout() {
    self.nickNameTitleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(24)
      $0.leading.equalToSuperview().offset(16)
    }
    
    self.nickNameTextField.snp.makeConstraints {
      $0.top.equalTo(self.nickNameTitleLabel.snp.bottom).offset(8)
      $0.leading.equalToSuperview().offset(16)
      $0.trailing.equalToSuperview().offset(-16)
      $0.height.equalTo(52)
    }
    
    self.emailTitleLabel.snp.makeConstraints {
      $0.top.equalTo(self.nickNameTextField.snp.bottom).offset(24)
      $0.leading.equalToSuperview().offset(16)
    }
    
    self.providerImageView.snp.makeConstraints {
      $0.top.equalTo(self.emailTitleLabel.snp.bottom).offset(8)
      $0.leading.equalToSuperview().offset(16)
    }
    
    self.emailLabel.snp.makeConstraints {
      $0.centerY.equalTo(self.providerImageView.snp.centerY)
      $0.leading.equalTo(self.providerImageView.snp.trailing).offset(8)
    }
    
    self.lineView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.centerY.equalTo(self.logoutBtn.snp.centerY)
      $0.width.equalTo(1.4)
      $0.height.equalTo(10)
    }
    
    self.logoutBtn.snp.makeConstraints {
      $0.top.equalTo(self.emailLabel.snp.bottom).offset(43.5)
      $0.centerX.equalToSuperview().offset(-30)
    }
    
    self.withdrawalBtn.snp.makeConstraints {
      $0.top.equalTo(self.emailLabel.snp.bottom).offset(43.5)
      $0.centerX.equalToSuperview().offset(30)
    }
    
    self.completedBtn.snp.makeConstraints {
      $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-45)
      $0.leading.equalToSuperview().offset(16)
      $0.trailing.equalToSuperview().offset(-16)
      $0.height.equalTo(52)
    }
  }
  
  func setUserInfo(nickName: String, email: String, provider: String) {
    self.nickNameTextField.text = nickName
    self.emailLabel.text = email
    
    switch provider {
    case "google.com":
      self.providerImageView.image = UIImage(named: "LoginGoogleImage")
    case "facebook.com":
      self.providerImageView.image = UIImage(named: "LoginFacebookImage")
    case "apple.com":
      self.providerImageView.image = UIImage(named: "LoginAppleImage")
    default:
      break
    }
  }
  
  func getNickName() -> String {
    guard let nickName = nickNameTextField.text else { return "" }
    
    return nickName
  }
  
  // MARK: - Action Button
  @objc private func logoutBtnDidTap(_ sender: UIButton) {
    self.delegate?.logoutDidTapBtn()
  }
  
  @objc private func withdrawalBtnDidTap(_ sender: UIButton) {
    self.delegate?.withdrawalDidTapBtn()
  }
  
  @objc private func completedBtnDidTap(_ sender: UIButton) {
    self.delegate?.completedDidTapBtn()
  }
}

// MARK: - Extension
