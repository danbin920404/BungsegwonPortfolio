//
//  MyPageNoneTableViewCell.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/22.
//

import UIKit

class MyPageNoneTableViewCell: UITableViewCell {
  // MARK: - Properties
  static let identifier = "MyPageNoneTableViewCell"
  private let noneTitleLabel = UILabel()
  
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
    self.contentView.addSubview(self.noneTitleLabel)
    
    self.contentView.backgroundColor = UIColor(
      red: 0.957,
      green: 0.957,
      blue: 0.957,
      alpha: 1
    )
    
    self.noneTitleLabel.text = "내가 쓴 댓글이 없어요."
    self.noneTitleLabel.textColor = UIColor(
      red: 0.769,
      green: 0.769,
      blue: 0.769,
      alpha: 1
    )
    self.noneTitleLabel.font = UIFont(
      name: "AppleSDGothicNeo-Regular",
      size: 14
    )
  }
  
  // MARK: - SetLayout
  private func setLayout() {
    self.noneTitleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(36)
      $0.centerX.equalToSuperview()
      $0.bottom.equalToSuperview()
    }
  }
  
  // MARK: - Action Button
}

// MARK: - Extension


