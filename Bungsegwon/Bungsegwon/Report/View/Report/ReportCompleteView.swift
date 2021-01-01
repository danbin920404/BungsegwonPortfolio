//
//  ReportCompleteView.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/22.
//

import UIKit

class ReportCompleteView: UIView {
  // MARK: - Properties
  let completeBtn = UIButton()
  
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
    self.completeBtn.layer.cornerRadius = 8
    self.completeBtn.layer.borderWidth = 1
    self.completeBtn.layer.borderColor = UIColor(
      red: 0.898,
      green: 0.898,
      blue: 0.898,
      alpha: 1
    ).cgColor
    self.completeBtn.layer.shadowColor = UIColor(
      red: 0,
      green: 0,
      blue: 0,
      alpha: 0.12
    ).cgColor // 색깔
    self.completeBtn.layer.shadowOffset = CGSize(width: 0, height: 4) // 위치조정
    self.completeBtn.layer.shadowRadius = 6 // 반경
    self.completeBtn.layer.shadowOpacity = 1 // alpha값
  }
  
  // MARK: - SetUI
  private func setUI() {
    self.addSubview(self.completeBtn)
    
    self.completeBtn.setTitle("등록하기", for: .normal)
    self.completeBtn.setTitleColor(
      .black
      , for: .normal
    )
    self.completeBtn.backgroundColor = UIColor(
      red: 1,
      green: 0.831,
      blue: 0.392,
      alpha: 1
    )
    self.completeBtn.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 14)
  }
  
  // MARK: - SetLayout
  private func setLayout() {
    self.completeBtn.snp.makeConstraints {
      $0.top.equalToSuperview().offset(24)
      $0.leading.equalToSuperview().offset(16)
      $0.trailing.equalToSuperview().offset(-16)
      $0.height.equalTo(52)
      $0.bottom.equalToSuperview().offset(-24)
    }
  }
  
  // MARK: - Action Button
}

// MARK: - Extension

