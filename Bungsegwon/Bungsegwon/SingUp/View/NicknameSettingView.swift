//
//  NicknameSettingView.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/22.
//

import UIKit

class NicknameSettingView: UIView {
  // MARK: - Properties
  private let titleLabel = UILabel()
  let nickNameTextField = UITextField()
  let completedBtn = UIButton()
  
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
      red: 0.898,
      green: 0.898,
      blue: 0.898,
      alpha: 1
    ).cgColor
    self.completedBtn.layer.shadowColor = UIColor(
      red: 0,
      green: 0,
      blue: 0,
      alpha: 0.12
    ).cgColor // 색깔
    self.completedBtn.layer.shadowOffset = CGSize(width: 0, height: 4) // 위치조정
    self.completedBtn.layer.shadowRadius = 6 // 반경
    self.completedBtn.layer.shadowOpacity = 1 // alpha값
  }
  
  // MARK: - SetUI
  private func setUI() {
    [
      self.titleLabel,
      self.nickNameTextField,
      self.completedBtn
    ].forEach {
      self.addSubview($0)
    }
    
    self.titleLabel.text = "닉네임을 설정해주세요."
    self.titleLabel.textAlignment = .center
    self.titleLabel.textColor = UIColor(
      red: 0.176,
      green: 0.176,
      blue: 0.176,
      alpha: 1
    )
    self.titleLabel.font = UIFont(
      name: "AppleSDGothicNeo-Bold",
      size: 24
    )
    
    self.nickNameTextField.placeholder = "멋진 이름을 지어주세요."
    let textFieldLeftPaddingView = UIView(
      frame: CGRect(x: 0, y: 0, width: 17, height: 0)
    )
    
    self.nickNameTextField.backgroundColor = .white
    self.nickNameTextField.leftViewMode = .always
    self.nickNameTextField.leftView = textFieldLeftPaddingView
    self.nickNameTextField.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 14)
    self.nickNameTextField.tintColor = UIColor(
      red: 1,
      green: 0.831,
      blue: 0.392,
      alpha: 1
    )
    
    
    self.completedBtn.setTitle(
      "시작하기",
      for: .normal
    )
    self.completedBtn.setTitleColor(
      .black,
      for: .normal
    )
    self.completedBtn.titleLabel?.font = UIFont(
      name: "AppleSDGothicNeo-Bold",
      size: 14
    )
    self.completedBtn.backgroundColor = UIColor(
      red: 1,
      green: 0.831,
      blue: 0.392,
      alpha: 1
    )
  }
  
  // MARK: - SetLayout
  private func setLayout() {
    self.titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(140)
      $0.leading.trailing.equalToSuperview()
    }
    
    self.nickNameTextField.snp.makeConstraints {
      $0.top.equalTo(self.titleLabel.snp.bottom).offset(56)
      $0.leading.equalToSuperview().offset(16)
      $0.trailing.equalToSuperview().offset(-16)
      $0.height.equalTo(52)
    }
    
    self.completedBtn.snp.makeConstraints {
      $0.top.equalTo(self.nickNameTextField.snp.bottom).offset(8)
      $0.leading.equalToSuperview().offset(16)
      $0.trailing.equalToSuperview().offset(-16)
      $0.height.equalTo(52)
    }
    
  }
  
  // MARK: - Action Button
}

// MARK: - Extension
