//
//  ReportTopNavigationView.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/22.
//

import UIKit

class ReportTopNavigationView: UIView {
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
      self.dismissBtn
    ].forEach {
      self.addSubview($0)
    }
    
    self.backgroundColor = .white
    
    self.titleLabel.text = "등록하기"
    self.titleLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 16)
    self.titleLabel.textColor = .black
    
    self.dismissBtn.setImage(UIImage(named: "BigDismissImage"), for: .normal)
  }
  
  // MARK: - SetLayout
  private func setLayout() {
    self.titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(23)
      $0.centerX.equalToSuperview()
      $0.bottom.equalToSuperview().offset(-15)
    }
    
    self.dismissBtn.snp.makeConstraints {
      $0.trailing.equalToSuperview().offset(-16)
      $0.centerY.equalTo(self.titleLabel.snp.centerY)
    }
  }
  
  // MARK: - Action Button
  
}

// MARK: - Extension

