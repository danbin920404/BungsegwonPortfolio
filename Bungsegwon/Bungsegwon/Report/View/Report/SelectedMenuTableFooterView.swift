//
//  SelectedMenuTableFooterView.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/22.
//

import UIKit

class SelectedMenuTableFooterView: UIView {
  // MARK: - Properties
  let moreBtn = UIButton()
  
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
      self.moreBtn
    ].forEach {
      self.addSubview($0)
    }
    self.backgroundColor = UIColor(red: 0.957, green: 0.957, blue: 0.957, alpha: 1)
    
    self.moreBtn.setImage(UIImage(named: "MoreBtnImage"), for: .normal)
  }
  
  // MARK: - SetLayout
  private func setLayout() {
    self.moreBtn.snp.makeConstraints {
      $0.top.equalToSuperview().offset(16)
      $0.leading.equalToSuperview().offset(16)
      $0.bottom.equalToSuperview().offset(-24)
    }
  }
  
  // MARK: - Configure
  
  // MARK: - Action Button
  
}

// MARK: - Extension

