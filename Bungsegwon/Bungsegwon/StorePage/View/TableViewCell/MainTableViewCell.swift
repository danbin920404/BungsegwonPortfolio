//
//  StorePageTableViewCell.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/23.
//

import UIKit
import NMapsMap

protocol MainTableViewCellDelegate: class {
  func likeDidTapBtn() -> Bool
  func modifyDidTapBtn()
}

class MainTableViewCell: UITableViewCell {
  // MARK: - Properties
  static let identifier = "MainTableViewCell"
  private let naverMapView = NMFMapView(
    frame: CGRect(
      x: 0,
      y: 0,
      width: UIScreen.main.bounds.width,
      height: UIScreen.main.bounds.width
    )
  )
  let dismissBtn = UIButton()
  weak var delegate: MainTableViewCellDelegate?
  
  private let contentsView = UIView()
  private let titleLabel = UILabel()
  
  private let likeContentsView = UIView()
  let likeBtn = UIButton()
  private let likeLabel = UILabel()
  
  private let modifyContentsView = UIView()
  let modifyBtn = UIButton()
  private let modifyLabel = UILabel()
  
  private let shareContentsView = UIView()
  let shareBtn = UIButton()
  private let shareLabel = UILabel()
  
  private let createdDateLabel = UILabel()
  private let createdNameLabel = UILabel()
  private let menuLabel = UILabel()
  
  private let marker = NMFMarker()
  
  // MARK: - View LifeCycle
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    self.setUI()
    self.setLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    self.marker.mapView = nil
  }
  
  override func layoutSubviews() {
    self.contentsView.layer.cornerRadius = 16
    self.contentsView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.12).cgColor
    self.contentsView.layer.shadowOffset = CGSize(width: -2, height: 2)
    self.contentsView.layer.shadowRadius = 8
    self.contentsView.layer.shadowOpacity = 1
    self.contentsView.layer.maskedCorners = [
      .layerMinXMaxYCorner,
      .layerMinXMinYCorner,
      .layerMaxXMinYCorner
    ]
    
    self.contentsView.layer.masksToBounds = false
  }
  
  // MARK: - SetUI
  private func setUI() {
    self.contentView.backgroundColor = .white
    
    [
      self.naverMapView,
      self.contentsView,
      self.createdDateLabel,
      self.createdNameLabel,
      self.menuLabel,
      self.dismissBtn
    ].forEach {
      self.contentView.addSubview($0)
    }
    
    self.dismissBtn.setImage(
      UIImage(named: "ArrowLeftImage"),
      for: .normal
    )
    
    self.contentsView.backgroundColor = .white
    
    [
      self.titleLabel,
      self.likeContentsView,
      self.modifyContentsView,
      self.shareContentsView
    ].forEach {
      self.contentsView.addSubview($0)
    }
    
    self.titleLabel.font = UIFont(
      name: "AppleSDGothicNeo-Bold",
      size: 24
    )
    
    [
      self.likeLabel,
      self.likeBtn,
    ].forEach {
      self.likeContentsView.addSubview($0)
    }
    
    self.likeBtn.addTarget(
      self,
      action: #selector(self.likeDidTapBtn),
      for: .touchUpInside
    )
    
    self.likeLabel.text = "찜"
    self.likeLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
    
    [
      self.modifyLabel,
      self.modifyBtn,
    ].forEach {
      self.modifyContentsView.addSubview($0)
    }
    
    self.modifyBtn.setImage(UIImage(named: "ModifyImage"), for: .normal)
    self.modifyBtn.addTarget(
      self,
      action: #selector(self.modifyDidTapBtn),
      for: .touchUpInside
    )
    
    self.modifyLabel.text = "수정"
    self.modifyLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
    
    [
      self.shareLabel,
      self.shareBtn,
    ].forEach {
      self.shareContentsView.addSubview($0)
    }
    
    self.shareBtn.setImage(UIImage(named: "ShareImage"), for: .normal)
    
    self.shareLabel.text = "공유"
    self.shareLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
    
    self.createdDateLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .vertical)
    self.createdDateLabel.textColor = UIColor(
      red: 0.769,
      green: 0.769,
      blue: 0.769,
      alpha: 1
    )
    self.createdDateLabel.font = UIFont(
      name: "AppleSDGothicNeo-Regular",
      size: 13
    )
    
    self.createdNameLabel.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .vertical)
    self.createdNameLabel.textColor = UIColor(
      red: 0.769,
      green: 0.769,
      blue: 0.769,
      alpha: 1
    )
    self.createdNameLabel.font = UIFont(
      name: "AppleSDGothicNeo-Regular",
      size: 13
    )
    
    self.menuLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .vertical)
    self.menuLabel.text = "메뉴"
    self.menuLabel.textColor = .black
    self.menuLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 16)
    
  }
  
  // MARK: - SetLayout
  private func setLayout() {
    self.naverMapView.snp.makeConstraints {
      let deviceWidth = UIScreen.main.bounds.width
      $0.leading.trailing.top.equalToSuperview()
      $0.height.equalTo(deviceWidth / 1.2)
    }
    
    self.dismissBtn.snp.makeConstraints {
      $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(20)
      $0.leading.equalToSuperview().offset(13)
      $0.width.height.equalTo(24)
    }
    
    self.contentsView.snp.makeConstraints {
      $0.centerY.equalTo(self.naverMapView.snp.bottom)
      $0.leading.equalToSuperview().offset(16)
      $0.trailing.equalToSuperview().offset(-16)
    }
    
    self.titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(24)
      $0.centerX.equalToSuperview()
    }
    
    self.likeContentsView.snp.makeConstraints {
      $0.top.equalTo(self.titleLabel.snp.bottom).offset(19)
      $0.centerX.equalTo(self.contentView.snp.centerX)
      $0.bottom.equalToSuperview().offset(-14)
    }
    
    self.likeBtn.snp.makeConstraints {
      $0.top.leading.bottom.equalToSuperview().offset(0)
      $0.width.height.equalTo(24)
    }
    
    self.likeLabel.snp.makeConstraints {
      $0.centerY.equalTo(self.likeBtn)
      $0.leading.equalTo(self.likeBtn.snp.trailing).offset(4)
      $0.trailing.equalToSuperview()
    }
    
    self.modifyContentsView.snp.makeConstraints {
      $0.top.equalTo(self.titleLabel.snp.bottom).offset(19)
      $0.leading.equalToSuperview().offset(30)
      $0.bottom.equalToSuperview().offset(-14)
    }
    
    self.modifyBtn.snp.makeConstraints {
      $0.top.leading.bottom.equalToSuperview().offset(0)
      $0.width.height.equalTo(24)
    }
    
    self.modifyLabel.snp.makeConstraints {
      $0.centerY.equalTo(self.modifyBtn)
      $0.leading.equalTo(self.modifyBtn.snp.trailing).offset(4)
      $0.trailing.equalToSuperview()
    }
    
    self.shareContentsView.snp.makeConstraints {
      $0.top.equalTo(self.titleLabel.snp.bottom).offset(19)
      $0.trailing.equalToSuperview().offset(-30)
      $0.bottom.equalToSuperview().offset(-14)
    }
    
    self.shareBtn.snp.makeConstraints {
      $0.top.leading.bottom.equalToSuperview().offset(0)
      $0.width.height.equalTo(24)
    }
    
    self.shareLabel.snp.makeConstraints {
      $0.centerY.equalTo(self.shareBtn)
      $0.leading.equalTo(self.shareBtn.snp.trailing).offset(4)
      $0.trailing.equalToSuperview()
    }
    
    self.createdDateLabel.snp.makeConstraints {
      $0.top.equalTo(self.contentsView.snp.bottom).offset(16)
      $0.leading.equalToSuperview().offset(16)
    }
    
    self.createdNameLabel.snp.makeConstraints {
      $0.top.equalTo(self.createdDateLabel.snp.bottom).offset(6)
      $0.leading.equalToSuperview().offset(16)
    }
    
    self.menuLabel.snp.makeConstraints {
      $0.top.equalTo(self.createdNameLabel.snp.bottom).offset(24)
      $0.leading.equalToSuperview().offset(16)
      $0.bottom.equalToSuperview().offset(-4)
    }
  }
  
  // MARK: - Configure
  func configure(coord: NMGLatLng, mainImageName: String, storeName: String, createdDate: String, createdName: String, isLike: Bool) {
    self.setStoreLocation(
      coord: coord,
      image: self.setImage(mainImageName)
    )
    
    self.titleLabel.text = storeName
    self.createdDateLabel.text = "등록/수정일 \(createdDate)"
    self.createdNameLabel.text = "등록인 \(createdName)"
    
    if isLike {
      self.likeBtn.setImage(UIImage(named: "HeartOnImage"), for: .normal)
    } else {
      self.likeBtn.setImage(UIImage(named: "HeartOffImage"), for: .normal)
    }
  }
  
  private func setStoreLocation(coord: NMGLatLng, image: UIImage) {
    let cameraUpdate = NMFCameraUpdate(scrollTo: coord)
    let image = NMFOverlayImage.init(
      image: image
    )
    
    self.marker.position = coord
    self.marker.iconImage = image
    self.marker.mapView = self.naverMapView
    
    cameraUpdate.animation = .fly
    cameraUpdate.animationDuration = 0.5
    
    self.naverMapView.zoomLevel = 16
    self.naverMapView.moveCamera(cameraUpdate)
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
    
    let image = UIImage(named: "Map\(setImageName)")
    
    return image!
  }
  
  // MARK: - Action Button
  @objc private func likeDidTapBtn(_ sender: UIButton) {
    // 로그인이 되었을 때만 이미지 바꿔주기
    let isLogin = self.delegate?.likeDidTapBtn()
    if isLogin == true {
      if self.likeBtn.currentImage!.isEqual(UIImage(named: "HeartOffImage")) {
        self.likeBtn.setImage(UIImage(named: "HeartOnImage"), for: .normal)
      } else {
        self.likeBtn.setImage(UIImage(named: "HeartOffImage"), for: .normal)
      }
    }
  }
  
  // 수정 버튼
  @objc private func modifyDidTapBtn(_ sender: UIButton) {
    
    self.delegate?.modifyDidTapBtn()

  }
}

// MARK: - Extension


