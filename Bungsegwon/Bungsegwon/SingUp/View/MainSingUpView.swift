//
//  MainSingUpView.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/22.
//

import UIKit

class MainSingUpView: UIView {
  // MARK: - Properties
  let titleImageView = UIImageView()
  let googleBtn = UIButton()
  let facebookBtn = UIButton()
  let appleBtn = UIButton()
  
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
    [
      self.titleImageView,
      self.googleBtn,
//      self.facebookBtn,
      self.appleBtn
    ].forEach {
      $0.layer.cornerRadius = 8
      $0.layer.shadowColor = UIColor(
        red: 0,
        green: 0,
        blue: 0,
        alpha: 0.12
      ).cgColor // 색깔
      $0.layer.shadowOffset = CGSize(width: 0, height: 4) // 위치조정
      $0.layer.shadowRadius = 6 // 반경
      $0.layer.shadowOpacity = 1 // alpha값
    }
  }
  
  // MARK: - SetUI
  private func setUI() {
    [
      self.titleImageView,
      self.appleBtn,
      self.facebookBtn,
      self.googleBtn
    ].forEach {
      self.addSubview($0)
    }
    
    self.backgroundColor = .white
    
    self.titleImageView.image = UIImage(named: "SignUpMainImage")
    
    self.googleBtn.setImage(
      UIImage(named: "GoogleLogoImage"),
      for: .normal
    )
    self.googleBtn.backgroundColor = UIColor(
      red: 0.993,
      green: 0.993,
      blue: 0.993,
      alpha: 1
    )
    
    self.facebookBtn.setImage(
      UIImage(named: "FacebookLogoImage"),
      for: .normal
    )
    self.facebookBtn.backgroundColor = UIColor(
      red: 0.094,
      green: 0.467,
      blue: 0.949,
      alpha: 1
    )
    
    self.appleBtn.setImage(
      UIImage(named: "AppleLogoImage"),
      for: .normal
    )
    self.appleBtn.backgroundColor = UIColor(
      red: 0,
      green: 0,
      blue: 0,
      alpha: 1
    )
  }
  
  // MARK: - SetLayout
  private func setLayout() {
    self.titleImageView.snp.makeConstraints {
      if UIScreen.main.bounds.height < 668 {
        $0.top.equalToSuperview().offset(51)
      } else {
        $0.top.equalToSuperview().offset(139)
      }
      $0.centerX.equalToSuperview()
      $0.height.equalTo(80)
    }
    
    self.appleBtn.snp.makeConstraints {
      $0.height.equalTo(52)
      $0.leading.equalToSuperview().offset(16)
      $0.trailing.equalToSuperview().offset(-16)
      $0.bottom.equalToSuperview().offset(-106)
    }
    
//    self.facebookBtn.snp.makeConstraints {
//      $0.bottom.equalTo(self.appleBtn.snp.top).offset(-8)
//      $0.leading.equalToSuperview().offset(16)
//      $0.trailing.equalToSuperview().offset(-16)
//    }
    
    self.googleBtn.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(16)
      $0.trailing.equalToSuperview().offset(-16)
      $0.bottom.equalTo(self.appleBtn.snp.top).offset(-8)
    }
    
   
    
    
  }
  
  // MARK: Function

  
  // MARK: - Action Button
}

// MARK: - Extension
