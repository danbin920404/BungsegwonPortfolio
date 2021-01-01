//
//  MainMapViewController.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/22.
//

import UIKit
import NMapsMap

final class MainMapViewController: UIViewController {
  // MARK: - Properties
  private let naverMapView = NaverMapView()
  private var markers = [NMFMarker]()
  private let locationManager = CLLocationManager()
  // 위경도 값을 받으면 내 위치 및 지정한 위치로 이동
  var currentLcation: CLLocationCoordinate2D = CLLocationCoordinate2D() {
    didSet {
      let lat = self.currentLcation.latitude
      let long = self.currentLcation.longitude
      let coord = NMGLatLng(lat: lat, lng: long)
      
      let cameraUpdate = NMFCameraUpdate(scrollTo: coord)
      cameraUpdate.animation = .fly
      cameraUpdate.animationDuration = 1
      self.naverMapView.naverMapView.positionMode = .direction
      self.naverMapView.naverMapView.moveCamera(cameraUpdate)
    }
  }
  
  
  // MARK: - View LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    print(StoreShared.shared.mapInfos,"처음 받아옴")
    self.setMapMarker()
    self.setUI()
    self.setLayout()
  }
  
  // 처음 맵에 뿌려줄 마커를 생성
  private func setMapMarker() {
    for i in 0 ..< StoreShared.shared.mapInfos.count {

      let image = NMFOverlayImage.init(
        image: UIImage(
          named: "Map\(self.setMapImage(getImageStr: StoreShared.shared.mapInfos[i].mainImageStr))"
        )!
      )
      let coord = StoreShared.shared.mapInfos[i].location
      
      let marker = NMFMarker(position: coord)
      marker.userInfo = ["storeId": StoreShared.shared.mapInfos[i].storeId]
      marker.iconImage = image
      
      marker.touchHandler = { (overlay) -> Bool in
        guard let storeId = overlay.userInfo["storeId"] as? String else {
          print("storeId가 없음 - MainMapViewController")
          return false
        }
        
        // 네트워크 통신할 동안 인디 present
        let indiVC = IndicatorViewController()
        
        indiVC.modalPresentationStyle = .overFullScreen
        self.present(indiVC, animated: false, completion: nil)
        // 이미 가져온 데이터가 있는지 확인 후 없다면 네트워크 통신을 한다
        let getStoreFireStoreService = GetStoreFireStoreService()
        getStoreFireStoreService.getStore(storeId: storeId, completionHandler: { data in
          if data == nil {
            self.noneStoreAlert()
            indiVC.isDismiss = true
          } else {
            let storeVC = StorePageViewController()
            
            storeVC.getData = data
            storeVC.hidesBottomBarWhenPushed = true
            // 네트워크 통신이 끝나면 indi Dismiss
            indiVC.isDismiss = true
            self.navigationController?.pushViewController(storeVC, animated: true)
          }
        })
        return false
      }
      
      self.markers.append(marker)
    }
    
    DispatchQueue.main.async { [weak self] in
      // 메인 스레드
      for marker in self!.markers {
        marker.mapView = self?.naverMapView.naverMapView
      }
    }
  }
  
  private func noneStoreAlert() {
    let alert = UIAlertController(
      title: "가게가 삭제되었어요.",
      message: nil,
      preferredStyle: .alert
    )
    let alertAction = UIAlertAction(
      title: "확인",
      style: .cancel,
      handler: nil
    )
    
    alert.addAction(alertAction)
    
    self.present(alert, animated: true, completion: nil)
  }
  
  private func setMapImage(getImageStr: String) -> String {
    switch getImageStr {
    case "붕어/잉어빵":
      return "붕어잉어빵"
    case "국화/옛날풀빵":
      return "국화옛날풀빵"
    case "호두과자":
      return "호두과자"
    case "땅콩빵":
      return "땅콩빵"
    case "계란빵":
      return "계란빵"
    case "바나나빵":
      return "바나나빵"
    case "타코야키":
      return "타코야키"
    case "호떡":
      return "호떡"
    case "떡볶이":
      return "떡볶이"
    case "튀김":
      return "튀김"
    case "순대":
      return "순대"
    case "어묵":
      return "어묵"
    default:
      break
    }
    return ""
  }
  
  private func getStore(_ storeId: String) {
    
  }
  
  // MARK: - SetUI
  private func setUI() {
    self.view.backgroundColor = .white
    self.navigationController?.isNavigationBarHidden = true
    self.tabBarController?.tabBar.tintColor = .white
    self.tabBarController?.tabBar.isTranslucent = false
    
    self.view.addSubview(self.naverMapView)
    
    self.locationManager.delegate = self
    self.checkAuthorizationStatus()
    
    // 카카오 우편서비스 상단 주소를 누르면
    let kakaoSearchViewTapGesture = UITapGestureRecognizer(
      target: self,
      action: #selector(self.kakaoSearchDidTapBtn)
    )
    self.naverMapView.kakaoSearchView.addGestureRecognizer(
      kakaoSearchViewTapGesture
    )
    
    // 내 위치로 돌아가는 함수
    self.naverMapView.myLocationBtn.addTarget(
      self,
      action: #selector(self.myLocationDidTapBtn),
      for: .touchUpInside
    )
    
    // 카카오 우편서비스에서 선택한 주소 받아오기
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.getKakaoSearch),
      name: Notification.Name("kakaoSearchResult"),
      object: nil
    )
    
    // 가게 작성을 하면 작성한 가게가 marker가 찍혀야 되니까 호출을 받는 notification
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.appendMarker),
      name: Notification.Name("appendMarker"),
      object: nil
    )
    
    // 내가 등록한 가게를 삭제하면 호출받음
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.deleteMarker),
      name: Notification.Name("deleteMarker"),
      object: nil
    )
  }
  
  // MARK: - SetLayout
  private func setLayout() {
    naverMapView.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalToSuperview()
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
    print("start")
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
      
      self.currentLcation = coordinate
    }
  }
  
  // MARK: - Action Button
  // 상단 뷰를 탭하면 카카오 우편서비스 present
  @objc private func kakaoSearchDidTapBtn(_ sender: UIButton) {
    let addressSearchVC = KakaoAddressViewController()
    
    addressSearchVC.modalTransitionStyle = .coverVertical
    self.present(addressSearchVC, animated: true)
  }
  
  // 카카오 우편서비스에서 주소를 선택하면 받아오는 함수
  @objc private func getKakaoSearch(_ notification: Notification) {
    guard let resultAddressStr = notification.userInfo?["addressStr"] as? String else {
      return print("카카오 우편서비스에서 가져온 값이 없음 - MainMapViewController")
    }
    
    self.naverMapView.addressStr = resultAddressStr
    // 주소를 위경도로 변환 해주기
    self.updatingLocation(resultAddressStr)
  }
  
  // 내 위치로 돌아가는 함수
  @objc private func myLocationDidTapBtn(_ sender: UIButton) {
    self.locationManager.startUpdatingLocation()
  }
  
  @objc private func appendMarker(_ notification: Notification) {
    // notification에서 받아온 storeId값이 있으면 수정한 데이터 이므로 기존에 있던 marker를 삭제해준다
    guard let storeId = notification.userInfo?["storeId"] as? String else { return }
    
    if !storeId.isEmpty {
      print("삭제 전",StoreShared.shared.mapInfos)
      for i in 0 ..< StoreShared.shared.mapInfos.count {
        if StoreShared.shared.mapInfos[i].storeId == storeId {
          print("삭제하려고 함", i, StoreShared.shared.mapInfos[i].storeId)
          self.markers[i].mapView = nil
          self.markers.remove(at: i)
          StoreShared.shared.mapInfos.remove(at: i)
          print("기존 마커 삭제 완료")
          break
        }
      }
    }
    
    let lastIndex = StoreShared.shared.mapInfos.endIndex - 1
    let mapInfo = StoreShared.shared.mapInfos[lastIndex]
    let coord = mapInfo.location
    let marker = NMFMarker(position: coord)
    let image = NMFOverlayImage.init(
      image: UIImage(
        named: "Map\(self.setMapImage(getImageStr: mapInfo.mainImageStr))"
      )!
    )
    self.markers.append(marker)
    
    marker.userInfo = ["storeId": mapInfo.storeId]
    marker.iconImage = image
    
    marker.touchHandler = { (overlay) -> Bool in
      guard let storeId = overlay.userInfo["storeId"] as? String else {
        print("storeId가 없음 - MainMapViewController")
        return false
      }
      
      // 네트워크 통신할 동안 인디 present
      let indiVC = IndicatorViewController()
      
      indiVC.modalPresentationStyle = .overFullScreen
      self.present(indiVC, animated: false, completion: nil)
      // 이미 가져온 데이터가 있는지 확인 후 없다면 네트워크 통신을 한다
      let getStoreFireStoreService = GetStoreFireStoreService()
      getStoreFireStoreService.getStore(storeId: storeId, completionHandler: { data in
        let storeVC = StorePageViewController()
        
        storeVC.getData = data
        storeVC.hidesBottomBarWhenPushed = true
        // 네트워크 통신이 끝나면 indi Dismiss
        indiVC.isDismiss = true
        self.navigationController?.pushViewController(storeVC, animated: true)
      })
      
      return false
    }
    
    DispatchQueue.main.async { [weak self] in
      // 메인 스레드
      marker.mapView = self?.naverMapView.naverMapView
    }
  }
  
  @objc private func deleteMarker(_ notification: Notification) {
    guard let storeId = notification.userInfo?["deleteMarker"] as? String else {
      return print("내가 등록한 가게 삭제에서 받아온 storeId값이 없음")
    }
    
    for i in 0 ..< StoreShared.shared.mapInfos.count {
      if StoreShared.shared.mapInfos[i].storeId == storeId {
        
        self.markers[i].mapView = nil
        self.markers.remove(at: i)
        StoreShared.shared.mapInfos.remove(at: i)
        
        break
      }
    }
  }
}

// MARK: - CLLocationManagerDelegate
extension MainMapViewController: CLLocationManagerDelegate {
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
    
    if (abs(current.timestamp.timeIntervalSinceNow) < 10) {
      let coordinate = current.coordinate
      
      print("위경도 받아옴 - MainMapViewController")
      self.currentLcation = coordinate
      self.locationManager.stopUpdatingLocation()
    }
  }
  
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    // 에러 처리
    print(error.localizedDescription, " - MainMapViewController")
    self.locationManager.stopUpdatingLocation()
  }
}

