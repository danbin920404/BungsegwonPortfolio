//
//  DescriptionTableViewCell.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/24.
//

import UIKit

class DescriptionTableViewCell: UITableViewCell {
  // MARK: - Properties
  static let identifier = "DescriptionTableViewCell"
  private let containerView = UIView()
  private let addressTitleLabel = UILabel()
  private let addressLabel = UILabel()
  private let detailAddressLabel = UILabel()
  private let descriptionTitleLabel = UILabel()
  private let descriptionLabel = UILabel()
  
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
      self.addressTitleLabel,
      self.addressLabel,
      self.detailAddressLabel,
      self.descriptionTitleLabel,
      self.descriptionLabel
    ].forEach {
      self.containerView.addSubview($0)
    }
    
    self.containerView.backgroundColor = .white
    
    self.addressTitleLabel.text = "주소"
    self.addressTitleLabel.textColor = .black
    self.addressTitleLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 16)
    self.addressTitleLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 247), for: .vertical)
    self.addressTitleLabel.setContentCompressionResistancePriority(UILayoutPriority(751), for: .vertical)
    
    self.addressLabel.textAlignment = .left
    self.addressLabel.textColor = UIColor(
      red: 0.38,
      green: 0.38,
      blue: 0.38,
      alpha: 1
    )
    self.addressLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
    self.addressLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 248), for: .vertical)
    self.addressLabel.setContentCompressionResistancePriority(UILayoutPriority(750), for: .vertical)
    
    self.detailAddressLabel.textColor = UIColor(
      red: 0.38,
      green: 0.38,
      blue: 0.38,
      alpha: 1
    )
    self.detailAddressLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
    self.detailAddressLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 249), for: .vertical)
    self.detailAddressLabel.setContentCompressionResistancePriority(UILayoutPriority(749), for: .vertical)
    
    self.descriptionTitleLabel.text = "상세설명"
    self.descriptionTitleLabel.textColor = .black
    self.descriptionTitleLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 16)
    self.descriptionTitleLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 250), for: .vertical)
    self.descriptionTitleLabel.setContentCompressionResistancePriority(UILayoutPriority(748), for: .vertical)
    
    self.descriptionLabel.textColor = UIColor(
      red: 0.38,
      green: 0.38,
      blue: 0.38,
      alpha: 1
    )
    self.descriptionLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
    self.descriptionLabel.numberOfLines = 0
    self.descriptionLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .vertical)
    self.descriptionLabel.setContentCompressionResistancePriority(UILayoutPriority(747), for: .vertical)
    
  }
  
  // MARK: - SetLayout
  private func setLayout() {
    self.containerView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.bottom.equalToSuperview().offset(-1)
    }
    
    self.addressTitleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(24)
      $0.leading.equalToSuperview().offset(16)
    }
    
    self.addressLabel.snp.makeConstraints {
      $0.top.equalTo(self.addressTitleLabel.snp.bottom).offset(6)
      $0.leading.equalToSuperview().offset(16)
      $0.trailing.equalToSuperview().offset(-16)
    }
    
    self.detailAddressLabel.snp.makeConstraints {
      $0.top.equalTo(self.addressLabel.snp.bottom).offset(2)
      $0.leading.equalToSuperview().offset(16)
      $0.trailing.equalToSuperview().offset(-16)
    }
    
    self.descriptionTitleLabel.snp.makeConstraints {
      $0.top.equalTo(self.detailAddressLabel.snp.bottom).offset(22)
      $0.leading.equalToSuperview().offset(16)
    }
    
    self.descriptionLabel.snp.makeConstraints {
      $0.top.equalTo(self.descriptionTitleLabel.snp.bottom).offset(6)
      $0.leading.equalToSuperview().offset(16)
      $0.trailing.equalToSuperview().offset(-16)
      $0.bottom.equalToSuperview().offset(-24)
    }
  }
  
  // MARK: - Configure
  func configure(address: String, detailAddress: String, description: String) {
    self.addressLabel.text = address
    self.detailAddressLabel.text = detailAddress
    self.descriptionLabel.text = description
  }
  
  // MARK: - Action Button
}

// MARK: - Extension


