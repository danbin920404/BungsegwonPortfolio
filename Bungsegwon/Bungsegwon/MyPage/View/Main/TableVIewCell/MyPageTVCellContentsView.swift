//
//  MyPageTVCellContentsView.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/22.
//

import UIKit

class MyPageTVCellContentsView: UIView {
  // MARK: - Properties
  let titleImageView = UIImageView()
  let titleMenuLabel = UILabel()
  let dateLabel = UILabel()
  let commentLabel = UILabel()
  
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
      self.titleImageView,
      self.titleMenuLabel,
      self.dateLabel,
      self.commentLabel
    ].forEach {
      self.addSubview($0)
    }
    
    self.backgroundColor = .white
    
    self.titleImageView.contentMode = .scaleAspectFit
    
    self.titleMenuLabel.textColor = .black
    self.titleMenuLabel.font = UIFont(
      name: "AppleSDGothicNeo-Bold",
      size: 14
    )
    
    self.dateLabel.textColor = UIColor(
      red: 0.769,
      green: 0.769,
      blue: 0.769,
      alpha: 1
    )
    self.dateLabel.font = UIFont(
      name: "AppleSDGothicNeo-Regular",
      size: 13
    )
    self.dateLabel.setContentCompressionResistancePriority(UILayoutPriority(751), for: .horizontal)
    self.dateLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .horizontal)
    
    
    self.commentLabel.textColor = .black
    self.commentLabel.font = UIFont(
      name: "AppleSDGothicNeo-Regular",
      size: 14
    )
    self.commentLabel.textAlignment = .left
    self.commentLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 250), for: .horizontal)
  }
  
  // MARK: - SetLayout
  private func setLayout() {
    self.titleImageView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(5)
      $0.leading.equalToSuperview().offset(16)
      $0.width.height.equalTo(36)
    }
    
    self.titleMenuLabel.snp.makeConstraints {
      $0.centerY.equalTo(self.titleImageView.snp.centerY)
      $0.leading.equalTo(self.titleImageView.snp.trailing).offset(8)
    }
    
    self.dateLabel.snp.makeConstraints {
      $0.top.equalTo(self.titleImageView.snp.bottom).offset(6)
      $0.leading.equalToSuperview().offset(16)
      $0.bottom.equalToSuperview().offset(-18)
    }
    
    self.commentLabel.snp.makeConstraints {
      $0.centerY.equalTo(self.dateLabel.snp.centerY)
      $0.leading.equalTo(self.dateLabel.snp.trailing).offset(12)
      $0.trailing.equalToSuperview().offset(-16)
    }
  }
  
  // MARK: - Action Button
}

// MARK: - Extension

