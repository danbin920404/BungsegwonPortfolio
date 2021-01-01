//
//  SettingsView.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/22.
//

import UIKit

class SettingsView: UIView {
  // MARK: - Properties
  let contentsTableView = UITableView()
  
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
    self.addSubview(self.contentsTableView)
    
    self.contentsTableView.backgroundColor = UIColor(
      red: 0.957,
      green: 0.957,
      blue: 0.957,
      alpha: 1
    )
    self.contentsTableView.isScrollEnabled = false
    self.contentsTableView.separatorStyle = .none
  }
  
  // MARK: - SetLayout
  private func setLayout() {
    self.contentsTableView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  // MARK: - Action Button
}

// MARK: - Extension
