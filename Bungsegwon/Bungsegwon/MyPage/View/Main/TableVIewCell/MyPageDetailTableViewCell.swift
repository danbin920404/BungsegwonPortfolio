//
//  MyPageDetailTableViewCell.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/22.
//

import UIKit

class MyPageDetailTableViewCell: UITableViewCell {
  // MARK: - Properties
  static let identifier = "MyPageDetailTableViewCell"
  private let containerView = UIView()
  private let menuTitleLabel = UILabel()
  private let addressLabel = UILabel()
  private let menuImageView = UIImageView()
  let deleteBtn = UIButton()
  
  // MARK: - View LifeCycle
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    self.setUI()
    self.setLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    self.containerView.layer.cornerRadius = 8
    self.containerView.layer.masksToBounds = false
  }
  
  // MARK: - SetUI
  private func setUI() {
    [
      self.containerView
    ].forEach {
      self.contentView.addSubview($0)
    }
    
    self.containerView.backgroundColor = .white
    
    [
      self.menuTitleLabel,
      self.addressLabel,
      self.menuImageView,
      self.deleteBtn
    ].forEach {
      self.containerView.addSubview($0)
    }
    
    self.contentView.backgroundColor = UIColor(
      red: 0.957,
      green: 0.957,
      blue: 0.957,
      alpha: 1
    )
    
    self.menuTitleLabel.textColor = .black
    self.menuTitleLabel.font = UIFont(
      name: "AppleSDGothicNeo-Bold",
      size: 14
    )
    
    self.addressLabel.textColor = .black
    self.addressLabel.font = UIFont(
      name: "AppleSDGothicNeo-Regular",
      size: 14
    )
    
    self.menuImageView.contentMode = .scaleAspectFit
    
    self.deleteBtn.setImage(
      UIImage(named: "DeleteImage"),
      for: .normal
    )
  }
  
  // MARK: - SetLayout
  private func setLayout() {
    self.containerView.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.equalToSuperview().offset(16)
      $0.trailing.equalToSuperview().offset(-16)
      $0.bottom.equalToSuperview().offset(-8)
    }
    
    self.menuImageView.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(16)
      $0.centerY.equalToSuperview()
      $0.width.height.equalTo(36)
    }
    
    self.menuTitleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(16)
      $0.leading.equalTo(self.menuImageView.snp.trailing).offset(8)
    }
    
    self.addressLabel.snp.makeConstraints {
      $0.top.equalTo(self.menuTitleLabel.snp.bottom).offset(8)
      $0.leading.equalTo(self.menuImageView.snp.trailing).offset(8)
      $0.bottom.equalToSuperview().offset(-16)
    }
    
    self.deleteBtn.snp.makeConstraints {
      $0.top.equalToSuperview().offset(4)
      $0.trailing.equalToSuperview().offset(-4)
    }
  }
  
  // MARK: - Configuer
  func configuer(imageName: String, address: String) {
    self.addressLabel.text = address
    self.menuTitleLabel.text = imageName
    
    let image = UIImage(named: "Menu\(self.setImage(imageName: imageName))")
    self.menuImageView.image = image
  }
  
  private func setImage(imageName: String) -> String {
    switch imageName {
    case "붕어/잉어빵":
      return "붕어잉어빵"
    case "국화/옛날풀빵":
      return "국화옛날풀빵"
    case "호두과자":
      return "호두과자"
    case "땅콩빵":
      return "땅콩빵"
    case "계란빵":
      return "계란빵"
    case "바나나빵":
      return "바나나빵"
    case "타코야키":
      return "타코야키"
    case "호떡":
      return "호떡"
    case "떡볶이":
      return "떡볶이"
    case "튀김":
      return "튀김"
    case "순대":
      return "순대"
    case "어묵":
      return "어묵"
    default:
      break
    }
    return ""
  }
  
  // MARK: - Action Button
}

// MARK: - Extension



