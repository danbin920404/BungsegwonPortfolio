//
//  StorePageTopView.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/23.
//

import UIKit

class StorePageTopView: UIView {
  // MARK: - Properties
  private let titleLabel = UILabel()
  let dismissBtn = UIButton()
  
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
    self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.12).cgColor
    self.layer.shadowOffset = CGSize(width: 0, height: 2)
    self.layer.shadowRadius = 8
    self.layer.shadowOpacity = 1
    self.layer.maskedCorners = [
      .layerMinXMaxYCorner,
      .layerMaxXMaxYCorner
    ]
    
    self.layer.masksToBounds = false
  }
  
  // MARK: - SetUI
  private func setUI() {
    self.backgroundColor = .white
    
    [
      self.titleLabel,
      self.dismissBtn
    ].forEach {
      self.addSubview($0)
    }
    
    self.titleLabel.text = "붕어/잉어빵"
    self.titleLabel.textColor = .black
    self.titleLabel.font = UIFont(
      name: "AppleSDGothicNeo-Bold",
      size: 16
    )
    
    self.dismissBtn.setImage(
      UIImage(named: "ArrowLeftImage"),
      for: .normal
    )
  }
  
  // MARK: - SetLayout
  private func setLayout() {
    self.titleLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.bottom.equalToSuperview().offset(-15)
    }
    
    self.dismissBtn.snp.makeConstraints {
      $0.centerY.equalTo(self.titleLabel.snp.centerY)
      $0.leading.equalToSuperview().offset(13)
    }
  }
  
  // MARK: - Action Button
}

// MARK: - Extension
