//
//  CommentsHeaderView.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/24.
//

import UIKit

class CommentsHeaderView: UIView {
  // MARK: - Properties
  private let titleLabel = UILabel()
  private let commentCountLabel = UILabel()
  
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
    self.backgroundColor = .white
    
    [
      self.titleLabel,
      self.commentCountLabel
    ].forEach {
      self.addSubview($0)
    }
    
    self.titleLabel.text = "댓글"
    self.titleLabel.textColor = .black
    self.titleLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 16)
    
    self.commentCountLabel.textColor = UIColor(
      red: 1,
      green: 0.831,
      blue: 0.392,
      alpha: 1
    )
    self.commentCountLabel.font = UIFont(
      name: "AppleSDGothicNeo-ExtraBold",
      size: 16
    )
  }
  
  // MARK: - SetLayout
  private func setLayout() {
    self.titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(24)
      $0.leading.equalToSuperview().offset(16)
      $0.bottom.equalToSuperview()
    }
    
    self.commentCountLabel.snp.makeConstraints {
      $0.centerY.equalTo(self.titleLabel.snp.centerY).offset(-1.5)
      $0.leading.equalTo(self.titleLabel.snp.trailing).offset(6)
      
    }
  }
  
  // MARK: - Configuer
  func configuer(count: Int) {
    self.commentCountLabel.text = String(count)
  }
  
  // MARK: - Action Button
}

// MARK: - Extension
