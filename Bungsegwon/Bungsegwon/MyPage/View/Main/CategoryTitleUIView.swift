//
//  CategoryTitleUIView.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/22.
//

import UIKit

protocol CategoryTitleViewDelegate {
  func presentVC(_ titleStr: String) -> Void
}

class CategoryTitleUIView: UIView {
  // MARK: - Properties
  private let titleLabel = UILabel()
  let moreBtn = UIButton()
  var delegate: CategoryTitleViewDelegate?
  
  // MARK: - View LifeCycle
  init(titleStr: String?) {
    super.init(frame: .zero)
    
    self.titleLabel.text = titleStr
    
    self.setUI()
    self.setLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - SetUI
  private func setUI() {
    [
      self.titleLabel,
      self.moreBtn
    ].forEach {
      self.addSubview($0)
    }
    
    self.backgroundColor = UIColor(
      red: 0.957,
      green: 0.957,
      blue: 0.957,
      alpha: 1
    )
    
    self.titleLabel.textColor = .black
    self.titleLabel.font = UIFont(
      name: "AppleSDGothicNeo-Bold",
      size: 16
    )
    
    let attrStr = NSMutableAttributedString(string: "더보기")
    let imageAttachment = NSTextAttachment()
    let image = UIImage(named: "MoreArrowRightImage")!
    
    imageAttachment.image = image
    imageAttachment.bounds = CGRect(x: 0, y: -7, width: 24, height: 24)
    attrStr.append(NSAttributedString(attachment: imageAttachment))
    
    self.moreBtn.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 13)
    self.moreBtn.setAttributedTitle(attrStr, for: .normal)
    self.moreBtn.sizeToFit()
    self.moreBtn.titleLabel?.textColor = UIColor(
      red: 0.651,
      green: 0.651,
      blue: 0.651,
      alpha: 1
    )
    self.moreBtn.addTarget(self, action: #selector(self.moreDidTapBtn), for: .touchUpInside)
  }
  
  // MARK: - SetLayout
  private func setLayout() {
    self.titleLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview().offset(16)
    }
    
    self.moreBtn.snp.makeConstraints {
      $0.top.bottom.equalToSuperview()
      $0.trailing.equalToSuperview().offset(-6)
      $0.height.equalTo(24)
    }
  }
  
  // MARK: - Action Button
  @objc private func moreDidTapBtn(_ sender: UIButton) {
    guard let titleStr = titleLabel.text else {
      return print("titleLabel에 Text가 없음 - CategoryTitleUIView")
    }
    
    self.delegate?.presentVC(titleStr)
  }
}

// MARK: - Extension
