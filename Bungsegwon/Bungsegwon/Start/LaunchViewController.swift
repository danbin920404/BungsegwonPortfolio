//
//  LaunchViewController.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/22.
//

import UIKit
import SnapKit
import FirebaseFirestore
import NMapsMap

class LaunchViewController: UIViewController {
  // MARK: - Properties
  private let launchImageView = UIImageView()
  let db = Firestore.firestore()
  
  // MARK: - View LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.setUI()
    self.setLayout()
  }
  // MARK: - SetUI
  private func setUI() {
    self.view.addSubview(self.launchImageView)
    
    self.view.backgroundColor = UIColor(red: 1, green: 0.86, blue: 0.41, alpha: 1)
    
    self.launchImageView.image = UIImage(named: "Launch")
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    self.networkMonitoring()
  }
  
  // MARK: - SetLayout
  private func setLayout() {
    self.launchImageView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.centerY.equalToSuperview().offset(-43)
    }
  }
  
  private func getData() {
    print("---------Map 데이터 가져오기 시작----------")
    GetMapsFireStoreService.getMaps { (querySnapshot) in
      guard let querySnapshot = querySnapshot else {
        return print("like에서 가져온 값이 잘못됨 - LaunchViewController")
      }
      // 가져온 maps데이터 StoreShared.shared.mapInfos에 넣기
      self.mapDataAppend(querySnapshot: querySnapshot)
      print("---------Map 데이터 다 가져옴----------")
      
      
      // 로그인이 되어있다면 찜, 등록, 댓글 가져오기 아니라면 네트워크 통신 안함
      let isLogin = UserDefaults.standard.value(forKey: "isLogin") as! Bool
      if isLogin == true {
        print("---------Like 데이터 가져오기 시작----------")
        GetLikeStoreFireStoreService.getLikeData { (querySnapshot) in
          guard let querySnapshot = querySnapshot else {
            return print("like에서 가져온 값이 잘못됨 - LaunchViewController")
          }
          // 내가 등록한 가게
          GetCreatedStroeService.getCreatedStroe { (querySnapshot) in
            guard let query = querySnapshot else { return }
            
            for doc in query.documents {
              let data = doc.data()
              let address = data["address"] as! String
              let id = data["id"] as! String
              let mainMenu = data["main_menu"] as! String
              let createdStore = CreatedStore(
                id: id,
                address: address,
                mainMenu: mainMenu
              )
              
              StoreShared.shared.createdStores.insert(createdStore, at: 0)
            }
            
            // 내가 쓴 댓글
            GetMyCommentFireStoreService.getMyComment { (querySnapshot) in
              guard let query = querySnapshot else { return }
              
              for doc in query.documents {
                let data = doc.data()
                let comment = data["comment"] as! String
                let id = data["id"] as! String
                let mainMenu = data["main_menu"] as! String
                let createdDate = data["created_at"] as! String
                let myComment = MyComment(
                  id: id,
                  comment: comment,
                  mainMenu: mainMenu,
                  createdDate: createdDate
                )
                
                StoreShared.shared.myComments.insert(myComment, at: 0)
              }
              
              self.rootVCPresent()
              print("---------myComment 데이터 가져 옴----------")
              return
            }
            
            print("---------createdStores 데이터 가져 옴----------")
          }
          self.dataAppend(querySnapshot: querySnapshot)
          print("---------Like 데이터 가져 옴----------")
        }
      } else {
        
        self.rootVCPresent()
      }
    }
  }
//  self.getCreatedStore()
  
  // 받아온 데이터를 StoreShared.shared.likeStore에 저장
  private func dataAppend(querySnapshot: QuerySnapshot) {
    for document in querySnapshot.documents {
      let data = document.data()
      let likeStore = LikeStore(
        id: data["id"] as! String,
        address: data["address"] as! String,
        mainMenu: data["main_menu"] as! String
      )
      
      StoreShared.shared.likeStore.insert(likeStore, at: 0)
    }
  }
  
  private func mapDataAppend(querySnapshot: QuerySnapshot) {
    for document in querySnapshot.documents {
      
      let imageName = document.data()["image_name"] as! String
      let locationStr = document.data()["location"] as! [String: Double]
      let lat = locationStr["latitude"]!
      let long = locationStr["longitude"]!
      let location = NMGLatLng(lat: lat, lng: long)
      let mapInfo = MapInfo(
        mainImageStr: imageName,
        storeId: document.data()["id"] as! String,
        location: location
      )

      StoreShared.shared.mapInfos.append(mapInfo)
    }
  }
  
  private func rootVCPresent() {
    let rootTC = MainTabBarController()
    
    UIApplication.shared.windows.first?.rootViewController = rootTC
    UIApplication.shared.windows.first?.makeKeyAndVisible()
  }
  
  // 네트워크 체크 함수
  private func networkMonitoring() {
    if NetworkMonitor.shared.isConneted {
      // 네트워크 체크 후 연결이 됐다면 기존의 root을 실제 Main으로 변경
      self.getData()
      
    } else {
      // 네트워크 체크 후 연결이 안 됐다면 될 때까지 연결 확인창 뜨게 함
      let alert: UIAlertController = UIAlertController(
        title: "네트워크 상태 확인",
        message: "네트워크가 불안정 합니다.",
        preferredStyle: .alert
      )
      let action: UIAlertAction = UIAlertAction(
        title: "다시 시도",
        style: .default,
        handler: { (ACTION) in
          self.networkMonitoring()
        })
      alert.addAction(action)
      self.present(alert, animated: true, completion: nil)
    }
  }
  
  // MARK: - Action Button
  
  
  deinit {
    print("deinit - LaunchVC")
  }
}

// MARK: - Extension

