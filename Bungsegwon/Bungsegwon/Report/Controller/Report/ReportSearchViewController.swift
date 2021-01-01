//
//  ReportSearchViewController.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/22.
//

import UIKit
import NMapsMap

class ReportSearchViewController: UIViewController {
  // MARK: - Properties
  private let reportSearchView = ReportSearchView()
  private let locationManager = CLLocationManager()
  private var searchLocation = CLLocation()
  private var addressStr = ""
  private var isMapTap: Bool = true {
    didSet {
      if !self.isMapTap {
        print("움직임을 멈춤")
      } else {
        print("움직임을 시작")
      }
    }
  }
  
  // MARK: - View LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.setUI()
    self.setLayout()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    self.locationManager.delegate = self
    self.checkAuthorizationStatus()
    print("화면 뜸")
  }
  
  // MARK: - SetUI
  private func setUI() {
    [
      self.reportSearchView
    ].forEach {
      self.view.addSubview($0)
    }
    
    self.reportSearchView.dismissBtn.addTarget(
      self,
      action: #selector(self.dismissDidTapBtn),
      for: .touchUpInside
    )
    
    self.reportSearchView.kakaoAddressSearchBtn.addTarget(
      self,
      action: #selector(self.kakaoDidTapbtn),
      for: .touchUpInside
    )
    
    self.reportSearchView.currentLocationBtn.addTarget(
      self,
      action: #selector(self.currentLocationDidTapBtn),
      for: .touchUpInside
    )
    
    self.reportSearchView.naverMapView.addCameraDelegate(delegate: self)
    
    self.reportSearchView.completedBtn.addTarget(
      self,
      action: #selector(self.completedDidTapBtn),
      for: .touchUpInside
    )
    
    // 카카오 우편서비스 주소를 받아옴
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.getKakaoSearchResult),
      name: NSNotification.Name("SearchVC"),
      object: nil
    )
  }
  
  // MARK: - SetLayout
  private func setLayout() {
    self.reportSearchView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  // MARK: - Func
  // 처음 Map뷰가 시작되면 사용자가 위치정보 공유 상태를 확인
  private func checkAuthorizationStatus() {
    switch CLLocationManager.authorizationStatus() {
    case .notDetermined:
      self.locationManager.requestWhenInUseAuthorization()
    case .restricted, .denied: break
    case .authorizedWhenInUse:
      fallthrough
    case .authorizedAlways:
      self.startUpdatingLocation()
    @unknown default: fatalError()
    }
  }
  
  // 위치정보 공유를 했다면 사용자에 위치정보를 받아오는 함수
  private func startUpdatingLocation() {
    let status = CLLocationManager.authorizationStatus()
    guard status == .authorizedAlways || status == .authorizedWhenInUse,
          CLLocationManager.locationServicesEnabled()
    else { return }
    
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    self.locationManager.distanceFilter = 10.0
    self.locationManager.startUpdatingLocation()
  }
  
  // 카카오 우편서비스에서 받아온 주소를 위경도로 변경 후에 네이버맵 위치 변경
  private func updatingLocation(_ addressStr: String) {
    print("\n---------- [ 주소 -> 위경도 ] ----------", addressStr)
    let geocoder = CLGeocoder()
    geocoder.geocodeAddressString(addressStr) { (placeMark, error) in
      if error != nil {
        return print(error!.localizedDescription, "error")
      }
      guard let coordinate = placeMark?.first?.location?.coordinate else { return }
      print("카카오에서 주소 받아옴")
      self.reportSearchView.currentLcation = coordinate
      
    }
  }
  
  // 위경도를 주소로
  private func reverseGeocode(location: CLLocation) {
    let geocoder = CLGeocoder()
    
    geocoder.reverseGeocodeLocation(location) { placeMark, error in
      if error != nil {
        return print(error!.localizedDescription)
      }
      
      guard let address = placeMark?.first,
            let administrativeArea = address.administrativeArea,
            let locality = address.locality,
            let name = address.name
      else { return }
      
      let addr = "\(administrativeArea) \(locality) \(name)"
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        self.reportSearchView.addressLabel.text = addr
        self.reportSearchView.isMapTap = false
        self.isMapTap = false
        self.addressStr = addr
        print("\(addr) ---------- [ 위경도 -> 주소 ] ----------")
      }
    }
  }
  
  // MARK: - Action Button
  @objc private func dismissDidTapBtn(_ sender: UIButton) {
    self.reportSearchView.naverMapView.positionMode = .disabled
    
    self.navigationController?.popViewController(animated: true)
  }
  
  @objc private func kakaoDidTapbtn(_ sender: UIButton) {
    let kakaoVC = KakaoAddressViewController()
    
    self.present(kakaoVC, animated: true, completion: nil)
  }
  
  // 내 위치로 가는 함수
  @objc private func currentLocationDidTapBtn(_ sender: UIButton) {
    self.locationManager.startUpdatingLocation()
  }
  
  @objc private func getKakaoSearchResult(_ notification: Notification) {
    guard let addressStr = notification.userInfo?["addressStr"] as? String else {
      return print("notification 받아 온 값이 잘못됨 - ReportSearchViewController")
    }
    
    self.updatingLocation(addressStr)
    self.reportSearchView.addressLabel.text = addressStr
  }
  
  @objc private func completedDidTapBtn(_ sender: UIButton) {
    NotificationCenter.default.post(
      name: NSNotification.Name(rawValue: "searchResult"),
      object: nil,
      userInfo: [
        "addressText": self.addressStr,
        "latitude": Double(self.searchLocation.coordinate.latitude),
        "longitude": Double(self.searchLocation.coordinate.longitude)
      ]
    )
    
    self.reportSearchView.naverMapView.positionMode = .disabled
    
    self.navigationController?.popViewController(animated: true)
  }
  
  deinit {
    print("deinit - ReportSearchViewController")
  }
}

// MARK: - CLLocationManagerDelegate
extension ReportSearchViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    switch status {
    case .authorizedWhenInUse, .authorizedAlways:
      self.locationManager.startUpdatingLocation()
    default:
      print("Unauthorized")
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let current = locations.last!
    self.locationManager.stopUpdatingLocation()
    if (abs(current.timestamp.timeIntervalSinceNow) < 10) {
      let coordinate = current.coordinate
      
      self.reportSearchView.currentLcation = coordinate
      self.reverseGeocode(location: current)
      self.locationManager.stopUpdatingLocation()
    }
  }
  
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    // 에러 처리
    print(error.localizedDescription, " - MainMapViewController")
    self.locationManager.stopUpdatingLocation()
  }
}


// 사용자가 맵을 움직임을 멈추면 위경도 값을 가져옴
extension ReportSearchViewController: NMFMapViewCameraDelegate, NMFMapViewTouchDelegate {
  func mapViewCameraIdle(_ mapView: NMFMapView) {
    let camPosition = mapView.cameraPosition
    
    let cLLocation = CLLocation(
      latitude: camPosition.target.lat,
      longitude: camPosition.target.lng
    )
//    let a = CLLocation
    
    self.searchLocation = cLLocation
    self.reverseGeocode(location: cLLocation)
    
    print(camPosition.target.lat, camPosition.target.lng)
  }
  
  func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) {
    if !self.isMapTap {
      self.isMapTap = true
      self.reportSearchView.isMapTap = true
    }
  }
}



