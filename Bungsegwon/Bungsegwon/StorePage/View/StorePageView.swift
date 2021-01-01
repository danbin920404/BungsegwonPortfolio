//
//  StorePageView.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/23.
//

import UIKit

class StorePageView: UIView {
  // MARK: - Properties
  let tableView = UITableView()
  let titleView = UIView()
  
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
      self.tableView,
    ].forEach {
      self.addSubview($0)
    }
    
  }
  
  // MARK: - SetLayout
  private func setLayout() {
    self.tableView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalToSuperview()
    }
    
    
  }
  
  // MARK: - Action Button
  
}

// MARK: - Extension
