//
//  MyPageMainTableViewCell.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/22.
//

import UIKit

class MyPageMainTableViewCell: UITableViewCell {
  // MARK: - Properties
  static let identifier = "MyPageMainTableViewCell"
  private let myPageTVCellContentsView = MyPageTVCellContentsView()
  
  // MARK: - View LifeCycle
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    self.setUI()
    self.setLayout()
  }
  
  override func layoutSubviews() {
    self.myPageTVCellContentsView.layer.cornerRadius = 8
    self.myPageTVCellContentsView.layer.masksToBounds = false
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - SetUI
  private func setUI() {
    self.contentView.addSubview(self.myPageTVCellContentsView)
  }
  
  // MARK: - SetLayout
  private func setLayout() {
    self.myPageTVCellContentsView.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.equalToSuperview().offset(16)
      $0.trailing.equalToSuperview().offset(-16)
      $0.bottom.equalToSuperview().offset(-8)
    }
  }
  
  // MARK: - Configuer
  func configuer(mainMenu: String, comment: String, createdDate: String) {
    self.myPageTVCellContentsView.commentLabel.text = comment
    self.myPageTVCellContentsView.titleMenuLabel.text = mainMenu
    self.myPageTVCellContentsView.dateLabel.text = createdDate
    
    let image = UIImage(named: "Menu\(self.setImage(imageName: mainMenu))")
    
    self.myPageTVCellContentsView.titleImageView.image = image
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



