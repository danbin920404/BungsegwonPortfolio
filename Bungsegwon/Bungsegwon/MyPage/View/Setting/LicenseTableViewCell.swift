//
//  LicenseTableViewCell.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/29.
//

import UIKit

class LicenseTableViewCell: UITableViewCell {
  // MARK: - Properties
  static let identifier = "LicenseTableViewCell"
  private let containerView = UIView()
  private let titleLabel = UILabel()
  private let presentBtn = UIButton()
  
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
      red: 0.957,
      green: 0.957,
      blue: 0.957,
      alpha: 1
    )
    
    self.containerView.backgroundColor = .white
    
    [
      self.titleLabel,
      self.presentBtn
    ].forEach {
      self.containerView.addSubview($0)
    }
    
    self.titleLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 16)
    self.titleLabel.textColor = .black
    
    self.presentBtn.setImage(UIImage(named: "PresentRigthImage"), for: .normal)
  }
  
  // MARK: - SetLayout
  private func setLayout() {
    self.containerView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.bottom.equalToSuperview().offset(-1)
    }
    
    self.titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(14.5)
      $0.leading.equalToSuperview().offset(16)
      $0.bottom.equalToSuperview().offset(-14.5)
    }
    
    self.presentBtn.snp.makeConstraints {
      $0.centerY.equalTo(self.titleLabel.snp.centerY)
      $0.trailing.equalToSuperview().offset(-11)
    }
  }
  
  // MARK: - Configuer
  func configuer(title: String) {
    self.titleLabel.text = title
  }
  
  // MARK: - Action Button
}

// MARK: - Extension


