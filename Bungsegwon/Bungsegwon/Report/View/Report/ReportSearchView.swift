//
//  ReportSearchView.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/22.
//

import UIKit
import NMapsMap

class ReportSearchView: UIView {
  // MARK: - Properties
  let naverMapView = NMFMapView(
    frame: CGRect.init(
      x: 0,
      y: 0,
      width: UIScreen.main.bounds.width,
      height: UIScreen.main.bounds.height
    )
  )
  var isMapTap: Bool = true {
    didSet {
      if self.isMapTap {
        DispatchQueue.main.async {
          self.completedBtn.layer.borderColor = UIColor(
            red: 0.769,
            green: 0.769,
            blue: 0.769,
            alpha: 1
          ).cgColor
          self.completedBtn.backgroundColor = UIColor(
            red: 0.769,
            green: 0.769,
            blue: 0.769,
            alpha: 1
          )
          self.addressLabel.textColor = UIColor(
            red: 0.769,
            green: 0.769,
            blue: 0.769,
            alpha: 1
          )
          self.addressLabel.text = "위치 이동 중"
        }
      } else {
        DispatchQueue.main.async {
          self.completedBtn.layer.borderColor = UIColor(
            red: 1,
            green: 0.831,
            blue: 0.392,
            alpha: 1
          ).cgColor
          self.completedBtn.backgroundColor = UIColor(
            red: 1,
            green: 0.831,
            blue: 0.392,
            alpha: 1
          )
          self.addressLabel.textColor = UIColor(
            red: 0.176,
            green: 0.176,
            blue: 0.176,
            alpha: 1
          )
        }
      }
    }
  }
  let dismissBtn = UIButton()
  let kakaoAddressSearchBtn = UIButton()
  let titleContainerView = UIView()
  let titleLabel = UILabel()
  let centerImageView = UIImageView()
  let addressLabel = UILabel()
  let completedBtn = UIButton()
  let currentLocationBtn = UIButton()
  var currentLcation: CLLocationCoordinate2D = CLLocationCoordinate2D() {
    didSet {
      let lat = self.currentLcation.latitude
      let long = self.currentLcation.longitude
      let coord = NMGLatLng(lat: lat, lng: long)
      let cameraUpdate = NMFCameraUpdate(scrollTo: coord)

      cameraUpdate.animation = .fly
      cameraUpdate.animationDuration = 1
      self.naverMapView.positionMode = .direction
      self.naverMapView.moveCamera(cameraUpdate)
      
    }
  }
  
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
    self.titleContainerView.layer.cornerRadius = 15
    self.titleContainerView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.14).cgColor
    self.titleContainerView.layer.shadowOffset = CGSize(width: 0, height: 1)
    self.titleContainerView.layer.shadowRadius = 16
    self.titleContainerView.layer.shadowOpacity = 1
    self.titleContainerView.layer.masksToBounds = false
    
    self.currentLocationBtn.layer.cornerRadius = 26
    self.currentLocationBtn.layer.borderWidth = 1
    self.currentLocationBtn.layer.borderColor = UIColor(
      red: 1,
      green: 0.831,
      blue: 0.392,
      alpha: 1
    ).cgColor
    self.currentLocationBtn.layer.shadowColor = UIColor(
      red: 0,
      green: 0,
      blue: 0,
      alpha: 0.25
    ).cgColor // 색깔
    self.currentLocationBtn.layer.shadowOffset = CGSize(width: 0, height: 2) // 위치조정
    self.currentLocationBtn.layer.shadowRadius = 4 // 반경
    self.currentLocationBtn.layer.shadowOpacity = 1 // alpha값
    
    self.naverMapView.positionMode = .direction
    self.completedBtn.layer.cornerRadius = 8
    self.completedBtn.layer.borderWidth = 1
    self.completedBtn.layer.shadowColor = UIColor(
      red: 0,
      green: 0,
      blue: 0,
      alpha: 0.12
    ).cgColor // 색깔
    self.completedBtn.layer.shadowOffset = CGSize(width: 0, height: 1) // 위치조정
    self.completedBtn.layer.shadowRadius = 6 // 반경
    self.completedBtn.layer.shadowOpacity = 1 // alpha값
    
    self.addressLabel.layer.cornerRadius = 8
    self.addressLabel.layer.borderWidth = 1
    self.addressLabel.layer.borderColor = UIColor(
      red: 0.898,
      green: 0.898,
      blue: 0.898,
      alpha: 1
    ).cgColor
    self.addressLabel.clipsToBounds = true
  }
  
  override func layoutIfNeeded() {
    
  }
  
  // MARK: - SetUI
  private func setUI() {
    [
      self.naverMapView,
      self.centerImageView,
      self.dismissBtn,
      self.kakaoAddressSearchBtn,
      self.titleContainerView,
      self.addressLabel,
      self.completedBtn,
      self.currentLocationBtn
    ].forEach {
      self.addSubview($0)
    }
    
    self.titleContainerView.addSubview(self.titleLabel)
    
    self.centerImageView.image = UIImage(named: "MarKerSearchImage")
    
    self.dismissBtn.setImage(
      UIImage(named: "DismissLeftBlackImage"),
      for: .normal
    )
    
    self.kakaoAddressSearchBtn.setImage(
      UIImage(named: "SearchBlackImage"),
      for: .normal
    )
    
    self.titleLabel.textAlignment = .center
    self.titleLabel.text = "지도를 움직여 위치를 설정하세요"
    self.titleLabel.textColor = UIColor(
      red: 0.176,
      green: 0.176,
      blue: 0.176,
      alpha: 1
    )
    self.titleLabel.font = UIFont(
      name: "AppleSDGothicNeo-Regular",
      size: 12
    )
    self.titleContainerView.backgroundColor = .white
    
    self.currentLocationBtn.setImage(
      UIImage(named: "MyLocationImage"),
      for: .normal
    )
    self.currentLocationBtn.backgroundColor = UIColor(
      red: 1,
      green: 0.831,
      blue: 0.392,
      alpha: 1
    )
    
    self.addressLabel.textAlignment = .center
    self.addressLabel.font = UIFont(
      name: "AppleSDGothicNeo-Medium",
      size: 16
    )
    self.addressLabel.backgroundColor = .white
    
    self.completedBtn.setTitle("확인", for: .normal)
    self.completedBtn.setTitleColor(.black, for: .normal)
    self.completedBtn.titleLabel?.font = UIFont(
      name: "AppleSDGothicNeo-Bold",
      size: 14
    )

    self.completedBtn.layer.borderColor = UIColor(
      red: 0.769,
      green: 0.769,
      blue: 0.769,
      alpha: 1
    ).cgColor
    self.completedBtn.backgroundColor = UIColor(
      red: 0.769,
      green: 0.769,
      blue: 0.769,
      alpha: 1
    )
    self.addressLabel.textColor = UIColor(
      red: 0.769,
      green: 0.769,
      blue: 0.769,
      alpha: 1
    )
    self.addressLabel.text = "위치 이동 중"
  }
  
  // MARK: - SetLayout
  private func setLayout() {
    self.naverMapView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalToSuperview()
    }
    self.centerImageView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.bottom.equalTo(self.naverMapView.snp.centerY)
    }
    
    self.dismissBtn.snp.makeConstraints {
      $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(20.38)
      $0.leading.equalToSuperview().offset(13)
      $0.width.height.equalTo(24)
    }
    
    self.kakaoAddressSearchBtn.snp.makeConstraints {
      $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(20.38)
      $0.trailing.equalToSuperview().offset(-13)
      $0.width.height.equalTo(24)
    }
    
    self.titleContainerView.snp.makeConstraints {
      $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(57)
      $0.leading.equalToSuperview().offset(93.5)
      $0.trailing.equalToSuperview().offset(-93.5)
      $0.height.equalTo(30)
    }
    
    self.titleLabel.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalToSuperview()
    }
    
    self.completedBtn.snp.makeConstraints {
      $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-50)
      $0.leading.equalToSuperview().offset(16)
      $0.trailing.equalToSuperview().offset(-16)
      $0.height.equalTo(52)
    }
    
    self.addressLabel.snp.makeConstraints {
      $0.bottom.equalTo(self.completedBtn.snp.top).offset(-8)
      $0.leading.equalToSuperview().offset(16)
      $0.trailing.equalToSuperview().offset(-16)
      $0.height.equalTo(73)
    }

    self.currentLocationBtn.snp.makeConstraints {
      $0.bottom.equalTo(self.addressLabel.snp.top).offset(-16)
      $0.trailing.equalToSuperview().offset(-16)
      $0.width.height.equalTo(52)
    }
  }
  
  // MARK: - Action Button
  
}

// MARK: - Extension

