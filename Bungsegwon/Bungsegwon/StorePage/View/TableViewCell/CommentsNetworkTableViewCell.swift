//
//  CommentsNetworkTableViewCell.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/26.
//

import UIKit

class CommentsNetworkTableViewCell: UITableViewCell {
  // MARK: - Properties
  static let identifier = "CommentsNetworkTableViewCell"
  let indicatorView = UIActivityIndicatorView()
  
  // MARK: - View LifeCycle
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    self.setUI()
    self.setLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - SetUI
  private func setUI() {
    self.contentView.backgroundColor = .white
    
    self.contentView.addSubview(self.indicatorView)
    
    self.indicatorView.color = .black
    self.indicatorView.startAnimating()
  }
  
  // MARK: - SetLayout
  private func setLayout() {
    self.indicatorView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(20)
      $0.centerX.equalToSuperview()
      $0.width.height.equalTo(50)
      $0.bottom.equalToSuperview().offset(-20)
    }
  }
  
  // MARK: - Action Button
}

// MARK: - Extension


