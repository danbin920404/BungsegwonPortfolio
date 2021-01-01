//
//  GetStoreFireStoreService.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/25.
//

import Foundation
import FirebaseFirestore
import NMapsMap

class GetStoreFireStoreService {
  let db = Firestore.firestore()

  func getStore(storeId: String, completionHandler: @escaping (GetStore?) -> Void) {
    let checkGetData = self.checkGetData(storeId: storeId)
    
    // 캐싱하고 있는 데이터가 있으면 캐싱하고 있는 데이터 반환 없다면(nil) 네트워크 통신
    if checkGetData == nil {
      let docRef = db.collection("stores").document(storeId)

      docRef.getDocument { (document, error) in
          if let document = document, document.exists {
              let data = document.data()
              print("Store 데이터 가져오기 성공")
            let isLike = self.isLikeStore(storeId: storeId)
            let getData = self.setData(data: data!, isLike: isLike)
            completionHandler(getData)
          } else {
              print("Document does not exist")
            completionHandler(nil)
          }
      }
    } else {
      completionHandler(checkGetData)
    }
    
  }
  private func checkGetData(storeId: String) -> GetStore? {
    let getStores = StoreShared.shared.getStores
    
    for i in 0 ..< getStores.count {
      if getStores[i].id == storeId {
        print("데이터를 캐싱하고 있음")
        return getStores[i]
      }
    }
    print("가지고 있는 데이터 없음 - 네트워크 통신 ->>>>>>>>>>>")
    return nil
  }
  
  private func setData(data: [String: Any], isLike: Bool) -> GetStore {
    let address = data["address"] as! String
    let detailAddress = data["detail_address"] as! String
    let mainMenu = data["main_menu"] as! String
    let name = data["name"] as! String
    let creator = data["creator"] as! String
    let description = data["description"] as! String
    let id = data["id"] as! String
    let isLike = isLike
    let createdDate = data["created_at"] as! String
    let location = data["location"] as! [String: Double]
    let latitude = location["latitude"]!
    let longitude = location["longitude"]!
    let naverLatLng = NMGLatLng(lat: latitude, lng: longitude)
    let menus = data["menus"] as! [[String : [[String : String]]]]
    
    let getStore = GetStore(
      address: address,
      detailAddress: detailAddress,
      mainMenu: mainMenu,
      name: name,
      creator: creator,
      description: description,
      id: id,
      isLike: isLike,
      createdDate: createdDate,
      naverLatLng: naverLatLng,
      menus: menus
    )
    
    StoreShared.shared.getStores.append(getStore)
    
    return getStore
  }
  
  private func isLikeStore(storeId: String) -> Bool {
    let likeStores = StoreShared.shared.likeStore
    
    for i in 0 ..< likeStores.count {
      if likeStores[i].id == storeId {
        return true
      }
    }
    
    return false
  }
}
 
