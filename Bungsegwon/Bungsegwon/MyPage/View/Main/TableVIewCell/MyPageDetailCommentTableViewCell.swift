//
//  MyPageDetailCommentTableViewCell.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/28.
//

import UIKit

class MyPageDetailCommentTableViewCell: UITableViewCell {
  // MARK: - Properties
  static let identifier = "MyPageDetailCommentTableViewCell"
  private let containerView = UIView()
  private let titleImageView = UIImageView()
  private let titleMenuLabel = UILabel()
  private let dateLabel = UILabel()
  private let commentLabel = UILabel()
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
      self.titleImageView,
      self.titleMenuLabel,
      self.dateLabel,
      self.commentLabel,
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
    
    self.deleteBtn.snp.makeConstraints {
      $0.top.equalToSuperview().offset(4)
      $0.trailing.equalToSuperview().offset(-4)
    }
  }
  
  // MARK: - Configuer
  func configuer(mainMenu: String, comment: String, createdDate: String) {
    self.commentLabel.text = comment
    self.titleMenuLabel.text = mainMenu
    self.dateLabel.text = createdDate
    
    let image = UIImage(named: "Menu\(self.setImage(imageName: mainMenu))")
    
    self.titleImageView.image = image
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


