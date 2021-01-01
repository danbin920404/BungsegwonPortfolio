//
//  TopNavigationView.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/22.
//

import UIKit

class TopNavigationView: UIView {
  // MARK: - Properties
  private let titleLabel = UILabel()
  let leftDismissBtn = UIButton()
  let rightDismissBtn = UIButton()
  /// true면 left false면 right 활성화
  private var isLeftAndRightBtn: Bool!
  
  // MARK: - View LifeCycle
  init(frame: CGRect, isLeftAndRightBtn: Bool, titleStr: String) {
    super.init(frame: frame)
    
    self.titleLabel.text = titleStr
    self.isLeftAndRightBtn = isLeftAndRightBtn
    self.setDismissBtnHidden(isLeftAndRightBtn: self.isLeftAndRightBtn)
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
    self.addSubview(self.titleLabel)
    
    self.backgroundColor = .white
    
    self.titleLabel.textColor = .black
    self.titleLabel.font = UIFont(
      name: "AppleSDGothicNeo-Bold",
      size: 16
    )
  }
  
  private func setDismissBtnHidden(isLeftAndRightBtn: Bool) {
    if isLeftAndRightBtn {
      self.rightDismissBtn.isHidden = true
      self.setDismissBtn(self.leftDismissBtn)
    } else {
      self.leftDismissBtn.isHidden = true
      self.setDismissBtn(self.rightDismissBtn)
    }
  }
  
  private func setDismissBtn(_ button: UIButton) {
    self.addSubview(button)
    
    switch button {
    case self.leftDismissBtn:
      button.setImage(UIImage(named: "ArrowLeftImage"), for: .normal)
    case self.rightDismissBtn:
      button.setImage(UIImage(named: "BigDismissImage"), for: .normal)
    default:
      break
    }
  }
  
  // MARK: - SetLayout
  private func setLayout() {
    self.titleLabel.snp.makeConstraints {
      $0.top.top.equalToSuperview().offset(23)
      $0.centerX.equalToSuperview()
      $0.bottom.equalToSuperview().offset(-15)
    }
    
    if isLeftAndRightBtn {
      self.leftDismissBtn.snp.makeConstraints {
        $0.leading.equalToSuperview().offset(12.91)
        $0.centerY.equalTo(self.titleLabel.snp.centerY)
      }
    } else {
      self.rightDismissBtn.snp.makeConstraints {
        $0.trailing.equalToSuperview().offset(-12.5)
        $0.centerY.equalTo(self.titleLabel.snp.centerY)
      }
    }
  }
  
  // MARK: - Action Button
}

// MARK: - Extension
