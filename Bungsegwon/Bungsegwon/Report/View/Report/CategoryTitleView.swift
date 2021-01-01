//
//  CategoryTitleView.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/22.
//

import UIKit

class CategoryTitleView: UIView {
  // MARK: - Properties
  private let categoryTitleLabel = UILabel()
  private let mustWriteImageView = UIImageView()
  private let subTitleLabel = UILabel()
  
  // MARK: - View LifeCycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.setUI()
    self.setLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - SetUI
  private func setUI() {
    [
      self.categoryTitleLabel,
      self.mustWriteImageView,
      self.subTitleLabel
    ].forEach {
      self.addSubview($0)
    }
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.configuerSubTilte),
      name: Notification.Name("isCatagoryEmpty"),
      object: nil
    )
    
    self.categoryTitleLabel.text = "메뉴"
    self.categoryTitleLabel.textColor = .black
    self.categoryTitleLabel.font = UIFont.init(
      name: "AppleSDGothicNeo-Bold",
      size: 16
    )
    
    self.mustWriteImageView.image = UIImage(named: "MustWriteImage")
    
    self.subTitleLabel.text = "여러 항목을 선택할 수 있어요."
    self.subTitleLabel.textColor = UIColor(
      red: 0.387,
      green: 0.387,
      blue: 0.387,
      alpha: 1
    )
    self.subTitleLabel.font = UIFont.init(
      name: "AppleSDGothicNeo-Regular",
      size: 12
    )
  }
  
  // MARK: - SetLayout
  private func setLayout() {
    self.categoryTitleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(24)
      $0.leading.equalToSuperview().offset(16)
      $0.bottom.equalToSuperview().offset(-8)
    }
    
    self.mustWriteImageView.snp.makeConstraints {
      $0.centerY.equalTo(self.categoryTitleLabel.snp.centerY)
      $0.leading.equalTo(self.categoryTitleLabel.snp.trailing).offset(1)
      $0.width.height.equalTo(24)
    }
    
    self.subTitleLabel.snp.makeConstraints {
      $0.centerY.equalTo(self.categoryTitleLabel.snp.centerY)
      $0.leading.equalTo(self.mustWriteImageView.snp.trailing).offset(1)
    }
  }
  
  // MARK: - Action Button
  @objc private func configuerSubTilte(_ notification: Notification) {
    guard let isEmpty = notification.userInfo?["isCatagoryEmpty"] as? Bool else {
      return print("notification 받아 온 값이 잘못됨 - CategoryTitleView")
    }
    
    if !isEmpty {
      self.subTitleLabel.text = "메뉴를 선택해주세요."
      self.subTitleLabel.textColor = .red
    } else {
      self.subTitleLabel.text = "여러 항목을 선택할 수 있어요."
      self.subTitleLabel.textColor = UIColor(
        red: 0.387,
        green: 0.387,
        blue: 0.387,
        alpha: 1
      )
    }
  }
}

// MARK: - Extension

