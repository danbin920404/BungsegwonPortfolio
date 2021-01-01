//
//  MyPageMainNoneCollectionViewCell.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/22.
//

import UIKit

class MyPageMainNoneCollectionViewCell: UICollectionViewCell {
  // MARK: - Properties
  static let identifier = "MyPageMainNoneCollectionViewCell"
  private let titleLabel = UILabel()
  
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
    self.contentView.addSubview(self.titleLabel)
    
    self.titleLabel.textColor = UIColor(
      red: 0.769,
      green: 0.769,
      blue: 0.769,
      alpha: 1
    )
    self.titleLabel.font = UIFont(
      name: "AppleSDGothicNeo-Regular",
      size: 14
    )
  }
  
  // MARK: - SetLayout
  private func setLayout() {
    self.titleLabel.snp.makeConstraints {
      $0.centerX.centerY.equalToSuperview()
    }
  }
  
  // MARK: - Configure
  func configure(titleStr: String) {
    self.titleLabel.text = titleStr
  }
  
  // MARK: - Action Button
  
}
// MARK: - Extension

