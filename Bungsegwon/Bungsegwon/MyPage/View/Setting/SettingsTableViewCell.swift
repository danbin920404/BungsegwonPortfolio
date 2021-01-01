//
//  SettingsTableViewCell.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/22.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
  // MARK: - Properties
  static let identifier = "SettingsTableViewCell"
  let containerView = UIView()
  private let titleLabel = UILabel()
  private let titleImageView = UIImageView()
  private let underLineView = UIView()
  
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
    [
      self.containerView,
    ].forEach {
      self.contentView.addSubview($0)
    }
    
    self.containerView.backgroundColor = .white
    
    [
      self.titleLabel,
      self.titleImageView
    ].forEach {
      self.containerView.addSubview($0)
    }
    
    self.contentView.backgroundColor = UIColor(
      red: 0.957,
      green: 0.957,
      blue: 0.957,
      alpha: 1
    )
    
    self.titleLabel.textColor = .black
    self.titleLabel.font = UIFont(
      name: "AppleSDGothicNeo-Regular",
      size: 16
    )
    
    self.titleImageView.image = UIImage(named: "MoreArrowRightImage")
  }
  
  // MARK: - SetLayout
  private func setLayout() {
    self.containerView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.bottom.equalToSuperview().offset(0)
    }
    self.titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(26.5)
      $0.leading.equalToSuperview().offset(16)
      $0.bottom.equalToSuperview().offset(-26.5)
    }
    
    self.titleImageView.snp.makeConstraints {
      $0.centerY.equalTo(self.titleLabel.snp.centerY)
      $0.trailing.equalToSuperview().offset(-16)
    }
  }
  
  // MARK: - Configure
  func configureTitleText(_ text: String, bottomMargin: CGFloat) {
    self.titleLabel.text = text
    
    self.containerView.snp.updateConstraints {
      $0.bottom.equalToSuperview().offset(-bottomMargin)
    }
  }
  
  // MARK: - Action Button
}

// MARK: - Extension

