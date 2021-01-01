//
//  MenusTableViewCell.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/24.
//

import UIKit

class MenusTableViewCell: UITableViewCell {
  // MARK: - Properties
  static let identifier = "MenusTableViewCell"
  private let containerView = UIView()
  private let menuLabel = UILabel()
  private let menuInfoLabel = UILabel()
  
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
    self.contentView.addSubview(self.containerView)
    
    self.contentView.backgroundColor = UIColor(
      red: 0.963,
      green: 0.963,
      blue: 0.963,
      alpha: 1
    )
    
    [
      self.menuLabel,
      self.menuInfoLabel
    ].forEach {
      self.containerView.addSubview($0)
    }
    
    self.containerView.backgroundColor = .white
    
    self.menuLabel.textColor = .black
    self.menuLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 14)
    
    self.menuInfoLabel.textColor = .black
    self.menuInfoLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
    
  }
  
  // MARK: - SetLayout
  private func setLayout() {
    self.containerView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.bottom.equalToSuperview().offset(-1)
    }
    
    self.menuLabel.snp.makeConstraints {
      $0.top.leading.equalToSuperview().offset(16)
      $0.bottom.equalToSuperview().offset(-16)
    }
    
    self.menuInfoLabel.snp.makeConstraints {
      $0.centerY.equalTo(self.menuLabel.snp.centerY)
      $0.leading.equalTo(self.menuLabel.snp.trailing).offset(6)
    }
  }
  
  // MARK: - Configure
  func configure(menuTitle: String, menuInfo: String) {
    self.menuLabel.text = menuTitle
    self.menuInfoLabel.text = menuInfo
  }
  
  // MARK: - Action Button
}

// MARK: - Extension


