//
//  ReportCompleteNextView.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/22.
//

import UIKit

class ReportCompleteNextView: UIView {
  // MARK: - Properties
  private let titleImageView = UIImageView()
  private let titleLabel = UILabel()
  private let subTitleLabel = UILabel()
  let dismissBtn = UIButton()
  
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
    self.dismissBtn.layer.cornerRadius = 8
    self.dismissBtn.layer.borderWidth = 1
    self.dismissBtn.layer.borderColor = UIColor(
      red: 0.898,
      green: 0.898,
      blue: 0.898,
      alpha: 1
    ).cgColor
    self.dismissBtn.layer.shadowColor = UIColor(
      red: 0,
      green: 0,
      blue: 0,
      alpha: 0.12
    ).cgColor // 색깔
    self.dismissBtn.layer.shadowOffset = CGSize(width: 0, height: 4) // 위치조정
    self.dismissBtn.layer.shadowRadius = 6 // 반경
    self.dismissBtn.layer.shadowOpacity = 1 // alpha값
  }
  
  // MARK: - SetUI
  private func setUI() {
    [
      self.titleImageView,
      self.titleLabel,
      self.subTitleLabel,
      self.dismissBtn
    ].forEach {
      self.addSubview($0)
    }
    
    self.titleImageView.image = UIImage(named: "ReportCompleteImage")
    
    self.titleLabel.text = "등록완료!"
    self.titleLabel.textColor = .black
    self.titleLabel.font = UIFont(
      name: "AppleSDGothicNeo-Bold",
      size: 26
    )
    
    self.subTitleLabel.numberOfLines = 0
    self.subTitleLabel.text = "이제 다른 사람들이 회원님이\n등록하신 가게를 검색할 수 있어요."
    self.subTitleLabel.textAlignment = .center
    self.subTitleLabel.font = UIFont(
      name: "AppleSDGothicNeo-Regular",
      size: 14
    )
    
    self.dismissBtn.setTitle("확인", for: .normal)
    self.dismissBtn.setTitleColor(
      .black
      , for: .normal
    )
    self.dismissBtn.backgroundColor = UIColor(
      red: 1,
      green: 0.831,
      blue: 0.392,
      alpha: 1
    )
    self.dismissBtn.titleLabel?.font = UIFont(
      name: "AppleSDGothicNeo-Bold",
      size: 14
    )
  }
  
  // MARK: - SetLayout
  private func setLayout() {
    self.titleImageView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(104)
      $0.centerX.equalToSuperview()
    }
    
    self.titleLabel.snp.makeConstraints {
      $0.top.equalTo(self.titleImageView.snp.bottom).offset(62)
      $0.centerX.equalToSuperview()
    }
    
    self.subTitleLabel.snp.makeConstraints {
      $0.top.equalTo(self.titleLabel.snp.bottom).offset(24)
      $0.centerX.equalToSuperview()
    }
    
    self.dismissBtn.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(16)
      $0.trailing.equalToSuperview().offset(-16)
      $0.height.equalTo(52)
      $0.bottom.equalToSuperview().offset(-56)
    }
  }
  
  // MARK: - Action Button
  
}

// MARK: - Extension

