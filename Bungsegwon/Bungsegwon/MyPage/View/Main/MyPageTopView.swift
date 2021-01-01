//
//  MyPageTopView.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/22.
//

import UIKit

class MyPageTopView: UIView {
  // MARK: - Properties
  let titleLabel = UILabel()
  let settingsBtn = UIButton()
  
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
    self.layer.cornerRadius = 16
    self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.08).cgColor
    self.layer.shadowOffset = CGSize(width: 0, height: 5)
    self.layer.shadowRadius = 2
    self.layer.shadowOpacity = 0.5
    self.layer.maskedCorners = [
      .layerMinXMaxYCorner,
      .layerMaxXMaxYCorner
    ]

    self.layer.masksToBounds = false
  }
  
  // MARK: - SetUI
  private func setUI() {
    [
      self.titleLabel,
      self.settingsBtn
    ].forEach {
      self.addSubview($0)
    }
    
    self.backgroundColor = UIColor(
      red: 1,
      green: 0.831,
      blue: 0.392,
      alpha: 1
    )
    
    self.titleLabel.textColor = .black
    self.titleLabel.numberOfLines = 0
    self.titleLabel.font = UIFont(
      name: "AppleSDGothicNeo-Bold",
      size: 26
    )
    
    
    
    self.settingsBtn.setImage(UIImage(named: "ConfigureImage"), for: .normal)
  }
  
  // MARK: - SetLayout
  private func setLayout() {
    self.titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(68)
      $0.leading.equalToSuperview().offset(16)
      $0.bottom.equalToSuperview().offset(-20)
    }
    
    self.settingsBtn.snp.makeConstraints {
      $0.top.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview().offset(-12)
      $0.width.height.equalTo(24)
    }
  }
  
  func setTitleLabel(titleStr: String) {
    let attrStr = NSMutableAttributedString(string: titleStr)
    let imageAttachment = NSTextAttachment()
    let paragraph = NSMutableParagraphStyle()
    
    imageAttachment.image = UIImage(named: "ArrowRightImage")
    imageAttachment.bounds = CGRect(x: 0, y: -3, width: 24, height: 24)
    paragraph.lineSpacing = 6
    attrStr.append(NSAttributedString(attachment: imageAttachment))
    attrStr.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraph, range: NSMakeRange(0, attrStr.length))
    self.titleLabel.attributedText = attrStr
    self.titleLabel.sizeToFit()
  }
  
  // MARK: - Action Button
}

// MARK: - Extension
