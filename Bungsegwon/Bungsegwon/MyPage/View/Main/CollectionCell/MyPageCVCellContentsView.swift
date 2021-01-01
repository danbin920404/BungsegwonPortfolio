//
//  MyPageCVCellContentsView.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/22.
//

import UIKit

class MyPageCVCellContentsView: UIView {
  // MARK: - Properties
  let menuTitleLabel = UILabel()
  let addressLabel = UILabel()
  let menuImageView = UIImageView()
  private let contentsStackView = UIStackView()
  
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
      self.menuImageView,
      self.contentsStackView,
    ].forEach {
      self.addSubview($0)
    }
    
    [
      self.menuTitleLabel,
      self.addressLabel
    ].forEach {
      self.contentsStackView.addSubview($0)
    }
    
    self.menuTitleLabel.text = "붕어/잉어빵"
    self.menuTitleLabel.textColor = .black
    self.menuTitleLabel.font = UIFont(
      name: "AppleSDGothicNeo-Bold",
      size: 14
    )
    
    self.addressLabel.text = "강남역 1번 출구"
    self.addressLabel.textColor = .black
    self.addressLabel.font = UIFont(
      name: "AppleSDGothicNeo-Regular",
      size: 14
    )
    
    self.menuImageView.image = UIImage(named: "Menu붕어잉어빵")
    self.menuImageView.contentMode = .scaleAspectFit
  }
  
  // MARK: - SetLayout
  private func setLayout() {
    self.menuImageView.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(16)
      $0.centerY.equalToSuperview()
      $0.width.height.equalTo(36)
    }
    
    self.menuTitleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(16)
      $0.leading.trailing.equalToSuperview()
    }

    self.addressLabel.snp.makeConstraints {
      $0.top.equalTo(self.menuTitleLabel.snp.bottom).offset(8)
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalToSuperview().offset(-16)
    }
    
    self.contentsStackView.snp.makeConstraints {
      $0.centerY.equalTo(self.menuImageView.snp.centerY)
      $0.leading.equalTo(self.menuImageView.snp.trailing).offset(8)
      $0.trailing.equalToSuperview().offset(-16)
      
    }
  }
  
  // MARK: - Action Button
}

// MARK: - Extension
