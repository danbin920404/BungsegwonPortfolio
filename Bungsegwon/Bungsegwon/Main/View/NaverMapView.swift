//
//  NaverMapView.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/22.
//

import UIKit
import NMapsMap

class NaverMapView: UIView {
  // MARK: - Properties
  var naverMapView = NMFMapView(
    frame: CGRect.init(
      x: 0,
      y: 0,
      width: UIScreen.main.bounds.width,
      height: UIScreen.main.bounds.height
    )
  )
  let myLocationBtn = UIButton()
  let kakaoSearchView = UIView()
  private let kakaoSearchImageView = UIImageView()
  let kakaoSearchViewLabel = UILabel()
  let filterBtn = UIButton()
  var addressStr: String = "어디에서 찾으세요?" {
    didSet {
      self.kakaoSearchViewLabel.text = self.addressStr
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
    self.myLocationBtn.layer.cornerRadius = 26
    self.myLocationBtn.layer.borderWidth = 1
    self.myLocationBtn.layer.borderColor = UIColor(
      red: 1,
      green: 0.831,
      blue: 0.392,
      alpha: 1
    ).cgColor
    self.myLocationBtn.layer.shadowColor = UIColor(
      red: 0,
      green: 0,
      blue: 0,
      alpha: 0.25
    ).cgColor // 색깔
    self.myLocationBtn.layer.shadowOffset = CGSize(width: 0, height: 2) // 위치조정
    self.myLocationBtn.layer.shadowRadius = 4 // 반경
    self.myLocationBtn.layer.shadowOpacity = 1 // alpha값
    
    self.kakaoSearchView.layer.cornerRadius = 48 / 2
    self.kakaoSearchView.layer.shadowColor = UIColor(
      red: 0,
      green: 0,
      blue: 0,
      alpha: 0.20
    ).cgColor // 색깔
    self.kakaoSearchView.layer.shadowOffset = CGSize(width: 0, height: 1) // 위치조정
    self.kakaoSearchView.layer.shadowRadius = 8 // 반경
    self.kakaoSearchView.layer.shadowOpacity = 1 // alpha값
    self.kakaoSearchView.layer.masksToBounds = false
  }
  
  // MARK: - SetUI
  private func setUI() {
    self.backgroundColor = .white
    
    [
      self.naverMapView,
      self.myLocationBtn,
      self.kakaoSearchView,
      self.kakaoSearchImageView,
      self.kakaoSearchViewLabel,
      self.filterBtn
    ].forEach {
      self.addSubview($0)
    }
    
    self.naverMapView.minZoomLevel = 9.0
    self.naverMapView.maxZoomLevel = 17.9
    
    self.myLocationBtn.setImage(UIImage(named: "MyLocationImage"), for: .normal)
    self.myLocationBtn.backgroundColor = UIColor(red: 1, green: 0.831, blue: 0.392, alpha: 1)
    
    self.kakaoSearchView.backgroundColor = .white
    
    self.kakaoSearchViewLabel.text = self.addressStr
    self.kakaoSearchViewLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 14)
    self.kakaoSearchViewLabel.textColor = .black
    
    self.kakaoSearchImageView.image = UIImage(named: "SearchImage")
    
    self.filterBtn.setImage(UIImage(named: "FilterImage"), for: .normal)
  }
  
  // MARK: - SetLayout
  private func setLayout() {
    self.naverMapView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalToSuperview()
    }
    
    self.myLocationBtn.snp.makeConstraints {
      $0.bottom.trailing.equalToSuperview().offset(-16)
      $0.height.width.equalTo(52)
    }
    
    self.kakaoSearchView.snp.makeConstraints {
      $0.top.equalTo(super.safeAreaLayoutGuide).offset(8)
      $0.leading.equalToSuperview().offset(16)
      $0.trailing.equalToSuperview().offset(-16)
      $0.height.equalTo(48)
    }
    
    self.kakaoSearchImageView.snp.makeConstraints {
      $0.centerY.equalTo(self.kakaoSearchView.snp.centerY)
      $0.leading.equalTo(self.kakaoSearchView.snp.leading).offset(16)
    }
    
    self.kakaoSearchViewLabel.snp.makeConstraints {
      $0.leading.equalTo(self.kakaoSearchImageView.snp.trailing).offset(4)
      $0.centerY.equalTo(self.kakaoSearchView.snp.centerY)
    }
    
    self.filterBtn.snp.makeConstraints {
      $0.centerY.equalTo(self.kakaoSearchView.snp.centerY)
      $0.trailing.equalTo(self.kakaoSearchView.snp.trailing)
      $0.width.equalTo(50)
      $0.height.equalTo(48)
    }
  }
  
  // MARK: - Action Button
}

// MARK: - Extension
