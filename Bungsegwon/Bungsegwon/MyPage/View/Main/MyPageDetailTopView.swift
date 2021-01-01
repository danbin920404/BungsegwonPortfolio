//
//  MyPageDetailTopView.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/22.
//

import UIKit

protocol MyPageDetailTopViewDelegate {
  func dismissVC() -> Void
}

class MyPageDetailTopView: UIView {
  // MARK: - Properties
  private let contentsView = UIView()
  let titleLabel = UILabel()
  private let dismissBtn = UIButton()
  var delegate: MyPageDetailTopViewDelegate?
  
  // MARK: - View LifeCycle
  init(frame: CGRect, titleStr: String) {
    super.init(frame: .zero)
    
    self.setTitle(titleStr: titleStr)
    self.setUI()
    self.setLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    self.contentsView.layer.cornerRadius = 16
    self.contentsView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.08).cgColor
    self.contentsView.layer.shadowOffset = CGSize(width: 0, height: 5)
    self.contentsView.layer.shadowRadius = 2
    self.contentsView.layer.shadowOpacity = 0.5
    self.contentsView.layer.maskedCorners = [
      .layerMinXMaxYCorner,
      .layerMaxXMaxYCorner
    ]
    self.contentsView.layer.masksToBounds = false
  }
  
  // MARK: - SetUI
  private func setUI() {
    self.addSubview(self.contentsView)
    
    self.backgroundColor = UIColor(
      red: 0.957,
      green: 0.957,
      blue: 0.957,
      alpha: 1
    )
    
    [
      self.titleLabel,
      self.dismissBtn
    ].forEach {
      self.contentsView.addSubview($0)
    }
    
    self.contentsView.backgroundColor = .white
    
    self.titleLabel.textColor = .black
    self.titleLabel.font = UIFont(
      name: "AppleSDGothicNeo-Bold",
      size: 16
    )
    
    self.dismissBtn.addTarget(
      self,
      action: #selector(dismissDidTapBtn),
      for: .touchUpInside
    )
    self.dismissBtn.setImage(
      UIImage(named: "ArrowLeftImage"),
      for: .normal
    )
  }
  
  private func setTitle(titleStr: String) {
    self.titleLabel.text = titleStr
  }
  
  // MARK: - SetLayout
  private func setLayout() {
    self.contentsView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalToSuperview()
    }
    
    self.titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(23.5)
      $0.centerX.equalToSuperview()
      $0.bottom.equalToSuperview().offset(-14)
    }
    
    self.dismissBtn.snp.makeConstraints {
      $0.centerY.equalTo(self.titleLabel.snp.centerY)
      $0.leading.equalToSuperview().offset(13)
      $0.width.height.equalTo(24)
    }
  }
  
  // MARK: - Action Button
  @objc private func dismissDidTapBtn(_ sender: UIButton) {
    self.delegate?.dismissVC()
  }
  
  deinit {
    print("deinit - MyPageDetailTopView")
  }
}

// MARK: - Extension

