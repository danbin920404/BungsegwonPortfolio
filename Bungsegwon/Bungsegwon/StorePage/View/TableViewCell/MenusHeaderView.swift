//
//  MenusHeaderView.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/24.
//

import UIKit

class MenusHeaderView: UIView {
  // MARK: - Properties
  private let containerView = UIView()
  private let titleImageView = UIImageView()
  private let titleLabel = UILabel()
  
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
    self.backgroundColor = UIColor(
      red: 0.963,
      green: 0.963,
      blue: 0.963,
      alpha: 1
    )
    
    self.addSubview(self.containerView)
    
    [
      self.titleImageView,
      self.titleLabel
    ].forEach {
      self.containerView.addSubview($0)
    }
    
    self.containerView.backgroundColor = .white
    
    self.titleImageView.image = UIImage(named: "Menu붕어잉어빵")
    self.titleImageView.contentMode = .scaleAspectFit
    
    self.titleLabel.text = "붕어/잉어빵"
    self.titleLabel.textColor = .black
    self.titleLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 14)
  }
  
  // MARK: - SetLayout
  private func setLayout() {
    self.containerView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.bottom.equalToSuperview().offset(-1)
    }
    
    self.titleImageView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(20)
      $0.leading.equalToSuperview().offset(16)
      $0.height.width.equalTo(36)
      $0.bottom.equalToSuperview()
    }
    
    self.titleLabel.snp.makeConstraints {
      $0.centerY.equalTo(self.titleImageView.snp.centerY)
      $0.leading.equalTo(self.titleImageView.snp.trailing).offset(4)
    }
  }
  
  // MARK: - Configure
  func configure(titleName: String) {
    self.titleLabel.text = titleName
    self.titleImageView.image = self.setImage(titleName)
  }
  
  private func setImage(_ imageName: String) -> UIImage {
    var setImageName = ""
    
    switch imageName {
    case "붕어/잉어빵":
      setImageName = "붕어잉어빵"
    case "국화/옛날풀빵":
      setImageName = "국화옛날풀빵"
    case "호두과자":
      setImageName = "호두과자"
    case "땅콩빵":
      setImageName = "땅콩빵"
    case "계란빵":
      setImageName = "계란빵"
    case "바나나빵":
      setImageName = "바나나빵"
    case "타코야키":
      setImageName = "타코야키"
    case "호떡":
      setImageName = "호떡"
    case "떡볶이":
      setImageName = "떡볶이"
    case "튀김":
      setImageName = "튀김"
    case "순대":
      setImageName = "순대"
    case "어묵":
      setImageName = "어묵"
    default:
      break
    }
    
    let image = UIImage(named: "Menu\(setImageName)")
    
    return image!
  }
  // MARK: - Action Button
}

// MARK: - Extension

