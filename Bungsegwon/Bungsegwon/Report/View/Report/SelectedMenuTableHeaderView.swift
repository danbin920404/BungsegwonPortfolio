//
//  SelectedMenuTableHeaderView.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/22.
//

import UIKit

class SelectedMenuTableHeaderView: UIView {
  // MARK: - Properties
  private let menuImageView = UIImageView()
  private let menuTitleLabel = UILabel()
  private let representationLabel = UILabel()
  
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
    self.representationLabel.layer.cornerRadius = 10
    self.representationLabel.clipsToBounds = true
  }
  
  // MARK: - SetUI
  private func setUI() {
    [
      self.menuImageView,
      self.menuTitleLabel,
      self.representationLabel
    ].forEach {
      self.addSubview($0)
    }
    self.backgroundColor = UIColor(
      red: 0.957,
      green: 0.957,
      blue: 0.957,
      alpha: 1
    )
    
    self.menuImageView.image = UIImage(named: "Menu붕어잉어빵")
    
    self.menuTitleLabel.text = "붕어/잉어빵"
    self.menuTitleLabel.textColor = .black
    self.menuTitleLabel.font = UIFont(
      name: "AppleSDGothicNeo-Bold",
      size: 14
    )
    
    self.representationLabel.text = "대표"
    self.representationLabel.textAlignment = .center
    self.representationLabel.textColor = .white
    self.representationLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 10)
    self.representationLabel.backgroundColor = UIColor(
      red: 1,
      green: 0.357,
      blue: 0.396,
      alpha: 1
    )
  }
  
  // MARK: - SetLayout
  private func setLayout() {
    self.menuImageView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(4)
      $0.leading.equalToSuperview().offset(16)
      $0.bottom.equalToSuperview().offset(-4)
    }
    
    self.menuTitleLabel.snp.makeConstraints {
      $0.centerY.equalTo(self.menuImageView.snp.centerY)
      $0.leading.equalTo(self.menuImageView.snp.trailing).offset(4)
    }
    
    self.representationLabel.snp.makeConstraints {
      $0.centerY.equalTo(self.menuTitleLabel)
      $0.leading.equalTo(self.menuTitleLabel.snp.trailing).offset(8)
      $0.height.equalTo(20)
      $0.width.equalTo(40)
    }
  }
  
  // MARK: - Configuer
  func configuer(_ imageStr: String, _ titleStr: String,_ isHidden: Bool) {
    self.menuImageView.image = UIImage(named: imageStr)
    
    self.menuTitleLabel.text = titleStr
    
    self.representationLabel.isHidden = isHidden
  }
  
  
  // MARK: - Action Button
  
}

// MARK: - Extension
