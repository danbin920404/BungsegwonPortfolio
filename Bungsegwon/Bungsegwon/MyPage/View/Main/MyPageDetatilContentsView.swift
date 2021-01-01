//
//  MyPageDetatilContentsView.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/22.
//

import UIKit

class MyPageDetatilContentsView: UIView {
  // MARK: - Properties
  let detailTableView = UITableView()
  
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
      self.detailTableView
    ].forEach {
      self.addSubview($0)
    }
    
    self.backgroundColor = UIColor(
      red: 0.957,
      green: 0.957,
      blue: 0.957,
      alpha: 1
    )
    
    self.detailTableView.separatorStyle = .none
    self.detailTableView.contentInset = UIEdgeInsets(
      top: 24,
      left: 0,
      bottom: 0,
      right: 0
    )
    self.detailTableView.backgroundColor = UIColor(
      red: 0.957,
      green: 0.957,
      blue: 0.957,
      alpha: 1
    )
  }
  
  // MARK: - SetLayout
  private func setLayout() {
    self.detailTableView.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  // MARK: - Action Button
  
  deinit {
    print("deinit - MyPageDetatilContentsView")
  }
}

// MARK: - Extension
