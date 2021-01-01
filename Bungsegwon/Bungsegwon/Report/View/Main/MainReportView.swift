//
//  MainReportView.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/22.
//

import UIKit

class MainReportView: UIView {
  // MARK: - Properties
  private let mainImageView = UIImageView()
  private let titleLabel = UILabel()
  private let subTitleLabel = UILabel()
  let reportBtn = UIButton()
  
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
    self.reportBtn.layer.cornerRadius = 8
    self.reportBtn.layer.borderWidth = 1
    self.reportBtn.layer.borderColor = UIColor(
      red: 0.898,
      green: 0.898,
      blue: 0.898,
      alpha: 1
    ).cgColor
    self.reportBtn.layer.shadowColor = UIColor(
      red: 0,
      green: 0,
      blue: 0,
      alpha: 0.12
    ).cgColor // 색깔
    self.reportBtn.layer.shadowOffset = CGSize(width: 0, height: 4) // 위치조정
    self.reportBtn.layer.shadowRadius = 6 // 반경
    self.reportBtn.layer.shadowOpacity = 1 // alpha값
  }
  
  // MARK: - SetUI
  private func setUI() {
    [
      self.mainImageView,
      self.titleLabel,
      self.subTitleLabel,
      self.reportBtn
    ].forEach {
      self.addSubview($0)
    }
    
    self.mainImageView.image = UIImage(named: "ReportMainImage")
    
    self.titleLabel.text = "등록해주세요."
    self.titleLabel.textColor = .black
    self.titleLabel.font = UIFont(
      name: "AppleSDGothicNeo-Bold",
      size: 26
    )
    
    self.subTitleLabel.numberOfLines = 0
    self.subTitleLabel.text = "주변에 아는 가게가 있다면\n사람들에게 알려주세요."
    self.subTitleLabel.textAlignment = .center
    self.subTitleLabel.font = UIFont(
      name: "AppleSDGothicNeo-Regular",
      size: 14
    )
    
    self.reportBtn.setTitle("등록 하러 가기", for: .normal)
    self.reportBtn.setTitleColor(
      .black
      , for: .normal
    )
    self.reportBtn.backgroundColor = UIColor(
      red: 1,
      green: 0.831,
      blue: 0.392,
      alpha: 1
    )
    self.reportBtn.titleLabel?.font = UIFont(
      name: "AppleSDGothicNeo-Bold",
      size: 14
    )
  }
  
  // MARK: - SetLayout
  private func setLayout() {
    self.mainImageView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(104)
      $0.centerX.equalToSuperview()
    }
    
    self.titleLabel.snp.makeConstraints {
      $0.top.equalTo(self.mainImageView.snp.bottom).offset(62)
      $0.centerX.equalToSuperview()
    }
    
    self.subTitleLabel.snp.makeConstraints {
      $0.top.equalTo(self.titleLabel.snp.bottom).offset(24)
      $0.centerX.equalToSuperview()
    }
    
    self.reportBtn.snp.makeConstraints {
      $0.bottom.equalToSuperview().offset(-56)
      $0.leading.equalToSuperview().offset(16)
      $0.trailing.equalToSuperview().offset(-16)
      $0.height.equalTo(52)
    }
  }
  
  // MARK: - Action Button
  
}

// MARK: - Extension
