//
//  SelectedMenuTitleView.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/22.
//

import UIKit

class SelectedMenuTitleView: UIView {
  // MARK: - Properties
  private let SelectedMenuTitleLabel = UILabel()
  private let mustWriteImageView = UIImageView()
  
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
      self.SelectedMenuTitleLabel,
      self.mustWriteImageView,
    ].forEach {
      self.addSubview($0)
    }
    
    self.SelectedMenuTitleLabel.text = "맛/수량/가격"
    self.SelectedMenuTitleLabel.textColor = .black
    self.SelectedMenuTitleLabel.font = UIFont.init(
      name: "AppleSDGothicNeo-Bold",
      size: 16
    )
    
    self.mustWriteImageView.image = UIImage(named: "MustWriteImage")
  }
  
  // MARK: - SetLayout
  private func setLayout() {
    self.SelectedMenuTitleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(24)
      $0.leading.equalToSuperview().offset(16)
      $0.bottom.equalToSuperview().offset(-8)
    }
    
    self.mustWriteImageView.snp.makeConstraints {
      $0.centerY.equalTo(self.SelectedMenuTitleLabel.snp.centerY)
      $0.leading.equalTo(self.SelectedMenuTitleLabel.snp.trailing).offset(1)
      $0.width.height.equalTo(24)
    }
  }
  
  // MARK: - Action Button
  
}

// MARK: - Extension
