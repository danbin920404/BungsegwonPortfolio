//
//  CreatedStoreFireStoreService.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/22.
//

import FirebaseFirestore
import NMapsMap

class CreatedStoreFireStoreService {
  let db = Firestore.firestore()
  var ref: DocumentReference? = nil
  
  func createdStoreFireStoreService(
    selectedMenus: [CollectionCount],
    textContainer: [[TextFieldStorage]],
    storeInfo: StoreInfo,
    storeId: String,
    completionHandler: @escaping () -> Void
  ) {
    let creator = UserDefaults.standard.value(forKey: "nickName") as! String
    let uid = UserDefaults.standard.value(forKey: "uid") as! String
    let menus = self.setData(data: textContainer, selectedMenus: selectedMenus)
    let createdDate = self.nowDate()
    let timestamp = Int(NSDate.timeIntervalSinceReferenceDate*1000).description
    var storeName = storeInfo.storeNameStr
    print("눌린 후",storeInfo.latitude, storeInfo.longitude)
    // 가게이름이 없을 경우 메인메뉴이름으로 지정해준다
    if storeName == "" {
      storeName = MenuStrArr.menuStrArr[selectedMenus.first!.sectionCount]
    }
    
    // 새로 생성일 경우 ------------------------------------------------------
    if storeId.isEmpty {
      // 우선 스토리스 콜렉션에 데이터를 생성
      self.ref = db.collection("stores").addDocument(data: [
        "name": storeName,
        "creator": creator,
        "uid": uid,
        "main_menu": MenuStrArr.menuStrArr[selectedMenus.first!.sectionCount],
        "address": storeInfo.addressStr,
        "detail_address": storeInfo.detailAddressStr,
        "description": storeInfo.descriptionStr,
        "created_at": createdDate,
        "location": ["latitude": storeInfo.latitude, "longitude": storeInfo.longitude],
        "menus": menus
      ]) { err in
        if let err = err {
          print("Error adding document: \(err)")
        } else {
          print("1차 - stores에 저장 성공")
          // 방금 만든 스토리에 doc에 id를 가져와서 넣어준다
          self.db.collection("stores").document(self.ref!.documentID).updateData(
            
            ["id": self.ref!.documentID]
            , completion: { _ in
              print("2차 - stores doc id를 다시 넣기 성공")
              // 내가 등록한 가게에 저장
              let uid = UserDefaults.standard.value(forKey: "uid") as! String
              let usersRef = self.db.collection("users")
              let userRef = usersRef.document(uid)
              let created_stores = userRef.collection("created_stores")
              // 내가 등록한 가게를 users에 넣어주기
              created_stores.document(self.ref!.documentID).setData([
                "id": self.ref!.documentID,
                "created_at": createdDate,
                "address": storeInfo.addressStr,
                "timestamp": timestamp,
                "main_menu": MenuStrArr.menuStrArr[selectedMenus.first!.sectionCount]
              ]) { err in
                if let err = err {
                  print("Error adding document: \(err)")
                } else {
                  print("3차 - 유저에 내가 등록한 가게 저장 성공")
                  
                  // 앱을 처음 시작할 떄 지도에 뿌려 줄 데이터를 생성
                  self.db.collection("stores_info").document(self.ref!.documentID).setData([
                    "id": self.ref!.documentID,
                    "location": ["latitude": storeInfo.latitude, "longitude": storeInfo.longitude],
                    "image_name": MenuStrArr.menuStrArr[selectedMenus.first!.sectionCount]
                  ]) { err in
                    if let err = err {
                      print("Error writing document: \(err)")
                    } else {
                      
                      // map에 보여줄 값을 로컬에 저장하고 뿌려준다
                      let imageName = MenuStrArr.menuStrArr[selectedMenus.first!.sectionCount]
                      let lat = storeInfo.latitude
                      let long = storeInfo.longitude
                      let location = NMGLatLng(lat: lat, lng: long)
                      let mapInfo = MapInfo(
                        mainImageStr: imageName,
                        storeId:  self.ref!.documentID,
                        location: location
                      )
                      StoreShared.shared.mapInfos.append(mapInfo)
                      
                      let createdStore = CreatedStore(
                        id: self.ref!.documentID,
                        address: storeInfo.addressStr,
                        mainMenu: imageName
                      )
                      print(self.ref!.documentID)
                      
                      StoreShared.shared.createdStores.insert(createdStore, at: 0)
                      
                      print("4차 - storesInfo에 저장 성공 -----------끝----------")
                      completionHandler()
                    }
                  }
                  
                }
              }
            })
        }
      }
    } else {
      // 수정 경우 ------------------------------------------------------
      // 등록한 사람의 정보도 변경이 필요하니까 등록한 사람의 내가 등록한 가게에 정보도 변경
      self.db.collection("stores").document(storeId).getDocument { (document, error) in
        let data = document?.data()
        let createdStoreUserUid = data!["uid"] as! String
        
        self.db.collection("stores").document(storeId).updateData([
          "name": storeName,
          "main_menu": MenuStrArr.menuStrArr[selectedMenus.first!.sectionCount],
          "address": storeInfo.addressStr,
          "detail_address": storeInfo.detailAddressStr,
          "description": storeInfo.descriptionStr,
          "created_at": createdDate,
          "location": ["latitude": storeInfo.latitude, "longitude": storeInfo.longitude],
          "menus": menus,
          "id": storeId
        ]) { (error) in
          if let error = error {
            print("수정 데이터 저장 실패 : \(error.localizedDescription)")
          } else {
            print("1차 - stores에 저장 성공")
            // 등록한 사람에 - 내가 등록한 가게에 다시 저장
            let usersRef = self.db.collection("users")
            let userRef = usersRef.document(createdStoreUserUid)
            let created_stores = userRef.collection("created_stores")
            
            created_stores.document(storeId).updateData([
              "id": storeId,
              "created_at": createdDate,
              "address": storeInfo.addressStr,
              "timestamp": timestamp,
              "main_menu": MenuStrArr.menuStrArr[selectedMenus.first!.sectionCount]
            ]) { (err) in
              if let err = err {
                print("Error adding document: \(err)")
              } else {
                print("3차 - 유저에 내가 등록한 가게 저장 성공")
                
                // 앱을 처음 시작할 떄 지도에 뿌려 줄 데이터를 생성
                self.db.collection("stores_info").document(storeId).setData([
                  "id": storeId,
                  "location": ["latitude": storeInfo.latitude, "longitude": storeInfo.longitude],
                  "image_name": MenuStrArr.menuStrArr[selectedMenus.first!.sectionCount]
                ]) { err in
                  if let err = err {
                    print("Error writing document: \(err)")
                  } else {
                    
                    // map에 보여줄 값을 로컬에 저장하고 뿌려준다
                    let imageName = MenuStrArr.menuStrArr[selectedMenus.first!.sectionCount]
                    let lat = storeInfo.latitude
                    let long = storeInfo.longitude
                    let location = NMGLatLng(lat: lat, lng: long)
                    let mapInfo = MapInfo(
                      mainImageStr: imageName,
                      storeId:  storeId,
                      location: location
                    )
                    
                    let usersRef = self.db.collection("users")
                    let userRef = usersRef.document(uid)
                    let likeStores = userRef.collection("liked_stores").document(storeId)
                    
                    // 서버 - 내가 찜한 가게가 있는지 확인 후 있으면 주소를 변경해준다
                    likeStores.getDocument { (document, error) in
                      if document!.exists {
                        likeStores.updateData(
                          [
                            "address": storeInfo.addressStr,
                            "main_menu": imageName
                          ])
                      }
                      
                      // 로컬 - 내가 찜한 가게가 있는지 확인 후 있으면 주소와 메인메뉴를 변경해준다
                      for i in 0 ..< StoreShared.shared.likeStore.count {
                        if StoreShared.shared.likeStore[i].id == storeId {
                          StoreShared.shared.likeStore[i].address = storeInfo.addressStr
                          StoreShared.shared.likeStore[i].mainMenu = imageName
                        }
                      }
                    }

                    // 수정한 사람이 가게를 등록한 사람인지 확인후 맞다면 로컬에 내가 등록한 가게를 다시 넣어준다
                    if createdStoreUserUid == uid {
                      print("등록한 사람이 동일")
                      let createdStore = CreatedStore(
                        id: storeId,
                        address: storeInfo.addressStr,
                        mainMenu: imageName
                      )
                      for i in 0 ..< StoreShared.shared.createdStores.count {
                        if StoreShared.shared.createdStores[i].id == storeId {
                          StoreShared.shared.createdStores.remove(at: i)
                          StoreShared.shared.createdStores.insert(createdStore, at: 0)
                          break
                        }
                      }
                    }
                    
                    StoreShared.shared.mapInfos.append(mapInfo)
                    print(StoreShared.shared.mapInfos)
                    print("4차 - storesInfo에 저장 성공 -----------끝----------")
                    completionHandler()
                  }
                } //
                
              }
            }
          }
        }
      }
      
      
    }
    
  }
  
  private func checkCreatedStore(storeId: String) -> Bool {
    for i in 0 ..< StoreShared.shared.createdStores.count {
      if StoreShared.shared.createdStores[i].id == storeId {
        
        return true
      }
    }
    
    return false
  }
  
  // 앱을 처음 시작할 떄 지도에 뿌려 줄 데이터를 생성하는 함수
  private func createdStoresInfo(storeInfo: StoreInfo, selectedMenus: [CollectionCount]) {
    self.db.collection("stores_Info").document(self.ref!.documentID).setData([
      "id": self.ref!.documentID,
      "location": ["latitude": storeInfo.latitude, "longitude": storeInfo.longitude],
      "image_name": MenuStrArr.menuStrArr[selectedMenus.first!.sectionCount]
    ]) { err in
      if let err = err {
        print("Error writing document: \(err)")
      } else {
        print("Document successfully written!")
      }
    }
  }
  
  private func setData(data: [[TextFieldStorage]], selectedMenus: [CollectionCount]) -> [[String : [[String : String]]]] {
    var menus = [[String : [[String : String]]]]()
    for i in 0 ..< data.count {
      let titleMenu = MenuStrArr.menuStrArr[selectedMenus[i].sectionCount]
      var textContainer = [[String: String]]()
      
      for n in 0 ..< data[i].count {
        let firstStr = data[i][n].firstText
        let secondStr = data[i][n].secondText
        textContainer.append([firstStr: secondStr])
      }
      menus.append([titleMenu: textContainer])
    }
    
    return menus
  }
  
  private func nowDate() -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.dateFormat = "yyyy.MM.dd"
    let nowDateStr = formatter.string(from: Date())
    
    return nowDateStr
  }
}

