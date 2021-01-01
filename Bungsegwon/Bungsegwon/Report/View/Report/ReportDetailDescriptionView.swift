//
//  ReportDetailDescriptionView.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/22.
//

import UIKit

class ReportDetailDescriptionView: UIView {
  // MARK: - Properties
  private let titleLabel = UILabel()
  let textView = UITextView()
  let textViewPlaceholderLabel = UILabel()
  
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
    self.textView.layer.cornerRadius = 8
    self.textView.layer.borderWidth = 1
    self.textView.clipsToBounds = true
    self.textView.layer.borderColor = UIColor(
      red: 0.898,
      green: 0.898,
      blue: 0.898,
      alpha: 1
    ).cgColor
  }
  
  // MARK: - SetUI
  private func setUI() {
    [
      self.titleLabel,
      self.textView,
      self.textViewPlaceholderLabel
    ].forEach {
      self.addSubview($0)
    }
    
    self.backgroundColor = UIColor(
      red: 0.957,
      green: 0.957,
      blue: 0.957,
      alpha: 1
    )
    
    self.titleLabel.text = "상세 설명"
    self.titleLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 16)
    self.titleLabel.textColor = .black
    
    self.textView.delegate = self
    self.textView.backgroundColor = .white
    self.textView.textColor = .black
    self.textView.tintColor = UIColor(
      red: 1,
      green: 0.831,
      blue: 0.392,
      alpha: 1
    )
    self.textView.font = UIFont(
      name: "AppleSDGothicNeo-Bold",
      size: 14
    )
    self.textView.textContainerInset = UIEdgeInsets(
      top: 4,
      left: 12,
      bottom: 4,
      right: 12
    )
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.checkDescription),
      name: Notification.Name("checkDescription"),
      object: nil
    )
    
    self.textViewPlaceholderLabel.text = "추가로 설명하기\n추가로 설명하기"
    self.textViewPlaceholderLabel.numberOfLines = 0
    self.textViewPlaceholderLabel.font = UIFont(
      name: "AppleSDGothicNeo-Regular",
      size: 14
    )
    self.textViewPlaceholderLabel.textColor = UIColor(
      red: 0.769,
      green: 0.769,
      blue: 0.769,
      alpha: 1
    )
  }
  
  // MARK: - SetLayout
  private func setLayout() {
    self.titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.equalToSuperview().offset(16)
    }
    
    self.textView.snp.makeConstraints {
      $0.top.equalTo(self.titleLabel.snp.bottom).offset(8)
      $0.leading.equalToSuperview().offset(16)
      $0.trailing.equalToSuperview().offset(-16)
      $0.height.equalTo(73)
      $0.bottom.equalToSuperview()
    }
    
    self.textViewPlaceholderLabel.snp.makeConstraints {
      $0.centerY.equalTo(self.textView)
      $0.leading.equalTo(self.textView.snp.leading).offset(16)
    }
  }
  
  // MARK: - Action Button
  @objc private func checkDescription(_ notification: Notification) {
    guard let textViewText = self.textView.text else {
      return print("textView에 text가 아예 없음 - ReportDetailDescriptionView")
    }
    print("checkDescription 시작")
    NotificationCenter.default.post(
      name: NSNotification.Name("getDescription"),
      object: nil,
      userInfo: ["textViewText": textViewText]
    )
  }
}

// MARK: - Extension
extension ReportDetailDescriptionView: UITextViewDelegate {
  func textViewDidChange(_ textView: UITextView) {
    if textView.text.isEmpty {
      self.textViewPlaceholderLabel.isHidden = false
    } else {
      self.textViewPlaceholderLabel.isHidden = true
    }
  }
}

