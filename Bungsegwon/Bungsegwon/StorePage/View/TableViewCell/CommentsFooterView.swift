//
//  CommentsFooterView.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/24.
//

import UIKit

class CommentsFooterView: UIView {
  // MARK: - Properties
  let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 52))
  let registerBtn = UIButton()
  
  // MARK: - View LifeCycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setUI()
    setLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    self.textField.layer.borderWidth = 1
    self.textField.layer.cornerRadius = 8
    self.textField.layer.borderColor = UIColor(
      red: 0.769,
      green: 0.769,
      blue: 0.769,
      alpha: 0.5
    ).cgColor
  }
  
  // MARK: - SetUI
  private func setUI() {
    self.backgroundColor = .white
    
    [
      self.textField,
      self.registerBtn
    ].forEach {
      self.addSubview($0)
    }
    
    self.registerBtn.setTitle("등록", for: .normal)
    self.registerBtn.setTitleColor(
      UIColor(red: 0.769, green: 0.769, blue: 0.769, alpha: 1),
      for: .normal
    )
    self.registerBtn.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 13)

    
    let btnWidth = ("1" as NSString).size(withAttributes: [NSAttributedString.Key.font : registerBtn.titleLabel!.font ?? ""]).width
    let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 1))
    let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 48 + btnWidth, height: 1))
    self.textField.placeholder = "댓글을 입력해주세요."
    self.textField.leftView = leftPaddingView
    self.textField.leftViewMode = .always
    self.textField.rightView = rightPaddingView
    self.textField.rightViewMode = .always
    self.textField.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 13)
    
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.textFieldReset),
      name: NSNotification.Name("textFieldReset"),
      object: nil
    )
  }
  
  // MARK: - SetLayout
  private func setLayout() {
    self.registerBtn.snp.makeConstraints {
      $0.top.equalTo(self.textField.snp.top)
      $0.trailing.equalTo(self.textField.snp.trailing).offset(0)
      $0.bottom.equalTo(self.textField.snp.bottom)
      let btnWidth = ("1" as NSString).size(withAttributes: [NSAttributedString.Key.font : registerBtn.titleLabel!.font ?? ""]).width
      $0.width.equalTo(btnWidth + 48)
    }
    
    self.textField.snp.makeConstraints {
      $0.top.equalToSuperview().offset(24)
      $0.leading.equalToSuperview().offset(16)
      $0.trailing.equalToSuperview().offset(-16)
      $0.height.equalTo(52)
      $0.bottom.equalToSuperview().offset(-10)
    }
  }
  
  // MARK: - Action Button
  @objc private func textFieldReset(_ notification: Notification) {
    self.textField.text = ""
  }
}

// MARK: - Extension


