//
//  MyPageMainCollectionViewCell.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/22.
//

import UIKit

class MyPageMainCollectionViewCell: UICollectionViewCell {
  // MARK: - Properties
  static let identifier = "MyPageMainCollectionViewCell"
  let myPageCVCellContentsView = MyPageCVCellContentsView()
  
  // MARK: - View LifeCycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.setUI()
    self.setLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    self.myPageCVCellContentsView.layer.cornerRadius = 8
    self.myPageCVCellContentsView.layer.masksToBounds = false
  }
  
  // MARK: - SetUI
  private func setUI() {
    self.contentView.addSubview(self.myPageCVCellContentsView)
    
    self.contentView.backgroundColor = UIColor(
      red: 0.957,
      green: 0.957,
      blue: 0.957,
      alpha: 1
    )

    self.myPageCVCellContentsView.backgroundColor = .white
  }
  
  // MARK: - SetLayout
  private func setLayout() {
    self.myPageCVCellContentsView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  // MARK: - Configuer
  func configuer(imageName: String, address: String) {
    self.myPageCVCellContentsView.addressLabel.text = address
    self.myPageCVCellContentsView.menuTitleLabel.text = imageName
    
    let image = UIImage(named: "Menu\(self.setImage(imageName: imageName))")
    self.myPageCVCellContentsView.menuImageView.image = image
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
