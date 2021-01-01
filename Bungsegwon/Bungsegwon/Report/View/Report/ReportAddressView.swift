//
//  ReportAddressView.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/22.
//

import UIKit

class ReportAddressView: UIView {
  // MARK: - Properties
  private let storeNameTitleLabel = UILabel()
  let storeNameTextField = UITextField()
  private let locationDescriptionTitleLabel = UILabel()
  private let locationDescriptionMustWriteImageView = UIImageView()
  let addressTextField = UITextField()
  let kakaoSearchBtn = UIButton()
  let detailAddressTextField = UITextField()
  var latitude: Double = 0
  var longitude: Double = 0
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.setUI()
    self.setLayout()
  }
  
  override func layoutSubviews() {
    self.kakaoSearchBtn.layer.cornerRadius = 8
    self.kakaoSearchBtn.layer.borderWidth = 1
    self.kakaoSearchBtn.layer.borderColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1).cgColor
    self.kakaoSearchBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.12).cgColor // 색깔
    self.kakaoSearchBtn.layer.shadowOffset = CGSize(width: 0, height: 4) // 위치조정
    self.kakaoSearchBtn.layer.shadowRadius = 6 // 반경
    self.kakaoSearchBtn.layer.shadowOpacity = 1 // alpha값
    
    [
      self.storeNameTextField,
      self.addressTextField,
      self.detailAddressTextField
    ].forEach {
      $0.layer.cornerRadius = 8
      $0.layer.borderWidth = 1
      $0.clipsToBounds = true
      $0.layer.borderColor = UIColor(
        red: 0.898,
        green: 0.898,
        blue: 0.898,
        alpha: 1
      ).cgColor
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - SetUI
  private func setUI() {
    [
      self.storeNameTitleLabel,
      self.storeNameTextField,
      self.locationDescriptionTitleLabel,
      self.locationDescriptionMustWriteImageView,
      self.addressTextField,
      self.kakaoSearchBtn,
      self.detailAddressTextField
    ].forEach {
      self.addSubview($0)
    }
    
    self.storeNameTitleLabel.text = "가게 이름"
    self.storeNameTitleLabel.textColor = .black
    self.storeNameTitleLabel.font = UIFont.init(
      name: "AppleSDGothicNeo-Bold",
      size: 16
    )
    [
      self.storeNameTextField,
      self.addressTextField,
      self.detailAddressTextField
    ].forEach {
      let textFieldLeftPaddingView = UIView(
        frame: CGRect(x: 0, y: 0, width: 17, height: 0)
      )
      
      $0.backgroundColor = .white
      $0.leftViewMode = .always
      $0.leftView = textFieldLeftPaddingView
      $0.tintColor = UIColor(
        red: 1,
        green: 0.831,
        blue: 0.392,
        alpha: 1
      )
      $0.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 14)
    }
    
    self.storeNameTextField.placeholder = "가게 이름을 입력해주세요."
    self.storeNameTextField.overrideUserInterfaceStyle = .light
    
    self.locationDescriptionTitleLabel.text = "위치"
    self.locationDescriptionTitleLabel.textColor = .black
    self.locationDescriptionTitleLabel.font = UIFont.init(
      name: "AppleSDGothicNeo-Bold",
      size: 16
    )
    
    self.locationDescriptionMustWriteImageView.image = UIImage(named: "MustWriteImage")
    
    self.addressTextField.placeholder = "위치를 검색해주세요."
    self.addressTextField.overrideUserInterfaceStyle = .light
    self.addressTextField.delegate = self
    self.addressTextField.isUserInteractionEnabled = false
    
    self.kakaoSearchBtn.setImage(UIImage(named: "MapTabBarSeletedImage"), for: .normal)
    self.kakaoSearchBtn.backgroundColor = .white
    
    self.detailAddressTextField.placeholder = "상세 위치 설명을 해주세요."
    self.detailAddressTextField.overrideUserInterfaceStyle = .light
    
    // ReportSearchVC에서 값을 넘겨 받음(가게 위치를 설정하는 곳)
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.getSearchResult),
      name: NSNotification.Name("searchResult"),
      object: nil
    )
    
    // 꼭 작성해야 하는 것들이 작성이 됐는지 확인하라고 신호를 받는 addObserver <- ReportVC
    // 작성이 됐다면 값을 돌려주고 true를 Post
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.checkInfo),
      name: NSNotification.Name("checkInfo"),
      object: nil
    )
  }
  
  // MARK: - SetLayout
  private func setLayout() {
    enum Layout: CGFloat {
      case leading = 16
      case trailing = -16
    }
    
    self.storeNameTitleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(24)
      $0.leading.equalToSuperview().offset(Layout.leading.rawValue)
    }
    
    self.storeNameTextField.snp.makeConstraints {
      $0.top.equalTo(self.storeNameTitleLabel.snp.bottom).offset(8)
      $0.leading.equalToSuperview().offset(Layout.leading.rawValue)
      $0.trailing.equalToSuperview().offset(Layout.trailing.rawValue)
      $0.height.equalTo(52)
    }
    
    self.locationDescriptionTitleLabel.snp.makeConstraints {
      $0.top.equalTo(self.storeNameTextField.snp.bottom).offset(20)
      $0.leading.equalToSuperview().offset(Layout.leading.rawValue)
    }
    
    self.locationDescriptionMustWriteImageView.snp.makeConstraints {
      $0.centerY.equalTo(self.locationDescriptionTitleLabel.snp.centerY)
      $0.leading.equalTo(self.locationDescriptionTitleLabel.snp.trailing).offset(1)
      $0.width.height.equalTo(24)
    }
    
    self.addressTextField.snp.makeConstraints {
      $0.top.equalTo(self.locationDescriptionTitleLabel.snp.bottom).offset(8)
      $0.leading.equalToSuperview().offset(Layout.leading.rawValue)
      $0.height.equalTo(52)
    }
    
    self.kakaoSearchBtn.snp.makeConstraints {
      $0.centerY.equalTo(self.addressTextField)
      $0.leading.equalTo(self.addressTextField.snp.trailing).offset(8)
      $0.trailing.equalToSuperview().offset(Layout.trailing.rawValue)
      $0.width.height.equalTo(52)
    }
    
    self.detailAddressTextField.snp.makeConstraints {
      $0.top.equalTo(self.addressTextField.snp.bottom).offset(8)
      $0.leading.equalToSuperview().offset(Layout.leading.rawValue)
      $0.trailing.equalToSuperview().offset(Layout.trailing.rawValue)
      $0.height.equalTo(52)
      $0.bottom.equalToSuperview()
    }
  }
  
  // MARK: - Action Button
  // ReportSearchVC에서 값을 넘겨 받음(가게 위치를 설정하는 곳)
  @objc private func getSearchResult(_ notification: Notification) {
    guard let addressText = notification.userInfo?["addressText"] as? String,
          let latitude = notification.userInfo?["latitude"] as? Double,
          let longitude = notification.userInfo?["longitude"] as? Double else {
      return print("ReportSearchVC에서 받아온 값이 없음 - ReportAddressView")
    }
    
    self.addressTextField.text = addressText
    self.latitude = latitude
    self.longitude = longitude
  }
  
  // 꼭 작성해야 하는 것들이 작성이 됐는지 확인하라고 신호를 받는 addObserver <- ReportVC
  // 작성이 됐다면 값을 돌려주고 true를 Post
  @objc private func checkInfo(_ notification: Notification) {
    guard let addressStr = self.addressTextField.text else { return }
    if addressStr.isEmpty {
      self.addressTextField.layer.borderColor = UIColor.red.cgColor
      self.addressTextField.attributedPlaceholder = NSAttributedString(
          string: "위치를 검색해주세요.",
          attributes: [NSAttributedString.Key.foregroundColor : UIColor.red]
        )
      return
    } else {
      self
        .addressTextField
        .layer
        .borderColor = UIColor(
          red: 0.898,
          green: 0.898,
          blue: 0.898,
          alpha: 1
        ).cgColor
      self.addressTextField.attributedPlaceholder = NSAttributedString(
          string: "위치를 검색해주세요.",
          attributes: [NSAttributedString.Key.foregroundColor : UIColor.black]
        )
    }
    
    self.passInfoPost()
  }
  
  private func passInfoPost() {
    let passInfoDic = [
      "storeName": self.storeNameTextField.text!,
      "addressStr": self.addressTextField.text!,
      "detailAddressStr": self.detailAddressTextField.text!,
      "latitude" : self.latitude,
      "longitude" : self.longitude
    ] as [String : Any]
    
    NotificationCenter.default.post(
      name: NSNotification.Name("passInfoAddress"),
      object: nil,
      userInfo: passInfoDic
    )
  }
}

// MARK: - Extension
extension ReportAddressView: UITextFieldDelegate {
  
}

