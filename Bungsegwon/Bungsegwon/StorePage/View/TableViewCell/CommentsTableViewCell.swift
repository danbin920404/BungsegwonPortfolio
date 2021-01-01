//
//  CommentsTableViewCell.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/24.
//

import UIKit

class CommentsTableViewCell: UITableViewCell {
  // MARK: - Properties
  static let identifier = "CommentsTableViewCell"
  private let nickNameLabel = UILabel()
  private let commentLabel = UILabel()
  private let dateLabel = UILabel()
  
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
    
    [
      self.nickNameLabel,
      self.commentLabel,
      self.dateLabel
    ].forEach {
      self.contentView.addSubview($0)
    }
    
    self.nickNameLabel.textColor = UIColor(
      red: 0.38,
      green: 0.38,
      blue: 0.38,
      alpha: 1
    )
    self.nickNameLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 14)
    
    self.commentLabel.textAlignment = .left
    self.commentLabel.textColor = UIColor(
      red: 0.38,
      green: 0.38,
      blue: 0.38,
      alpha: 1
    )
    self.commentLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
    self.commentLabel.numberOfLines = 0
    self.commentLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 249), for: .horizontal)
    self.commentLabel.setContentCompressionResistancePriority(UILayoutPriority(749), for: .horizontal)
    self.commentLabel.setContentCompressionResistancePriority(UILayoutPriority(749), for: .vertical)
    
    self.dateLabel.textColor = UIColor(
      red: 0.769,
      green: 0.769,
      blue: 0.769,
      alpha: 1
    )
    self.dateLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 13)
  }
  
  // MARK: - SetLayout
  private func setLayout() {
    self.nickNameLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(20)
      $0.leading.equalToSuperview().offset(16)
    }
    
    self.commentLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(20)
      $0.leading.equalTo(self.nickNameLabel.snp.trailing).offset(12)
      $0.trailing.equalToSuperview().offset(-16)
    }
    
    self.dateLabel.snp.makeConstraints {
      $0.top.equalTo(self.commentLabel.snp.bottom).offset(6)
      $0.leading.equalTo(self.commentLabel.snp.leading)
      $0.bottom.equalToSuperview().offset(-4)
    }
  }
  
  // MARK: - Congifuer
  func configuer(name: String, createdDate: String, comment: String) {
    self.nickNameLabel.text = name
    self.dateLabel.text = createdDate
    self.commentLabel.text = comment
  }
  
  // MARK: - Action Button
}

// MARK: - Extension


