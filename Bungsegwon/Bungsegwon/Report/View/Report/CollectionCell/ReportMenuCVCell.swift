//
//  ReportMenuCVCell.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/22.
//

import UIKit

class ReportMenuCVCell: UICollectionViewCell {
  // MARK: - Properties
  static let identifier = "ReportCollectionViewCell"
  private let menuImageView = UIImageView()
  private let menuLabel = UILabel()
  var isCellSelcted = false
  
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
      self.menuImageView,
      self.menuLabel
    ].forEach {
      self.contentView.addSubview($0)
    }
    
    self.backgroundColor = UIColor(
      red: 0.957,
      green: 0.957,
      blue: 0.957,
      alpha: 1
    )
    self.contentView.backgroundColor = UIColor(
      red: 0.957,
      green: 0.957,
      blue: 0.957,
      alpha: 1
    )
    
    self.menuImageView.sizeToFit()
    
    self.menuLabel.text = "붕어/잉어빵"
    self.menuLabel.textColor = .black
    self.menuLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 13)
  }
  
  // MARK: - SetLayout
  private func setLayout() {
    self.menuImageView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      
      let contentWidth = UIScreen.main.bounds.width - (CollectionLayout.cellSpacing * (CollectionLayout.itemCount - 1)) - (CollectionLayout.sectionInset.left + CollectionLayout.sectionInset.right)
      let cellWidth = contentWidth / CollectionLayout.itemCount
      
      $0.width.height.equalTo(cellWidth)
    }
    
    self.menuLabel.snp.makeConstraints {
      $0.top.equalTo(self.menuImageView.snp.bottom).offset(4)
      $0.centerX.equalToSuperview()
      $0.bottom.equalToSuperview()
    }
  }
  
  // MARK: - Configure
  func menuConfigure(titleImage: UIImage, titleStr: String) {
    self.menuImageView.image = titleImage
    
    self.menuLabel.text = titleStr
  }
  
  func didTapUpdateImageView(_ image: UIImage) {
    self.menuImageView.image = image
    
    self.isCellSelcted = !self.isCellSelcted
  }
  
  // MARK: - Action Button
  
}
// MARK: - Extension

