//
//  GetStore.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/25.
//

import Foundation
import NMapsMap

struct GetStore {
  let address: String
  let detailAddress: String
  let mainMenu: String
  let name: String
  let creator: String
  let description: String
  let id: String
  var isLike: Bool
  let createdDate: String
  let naverLatLng: NMGLatLng
  let menus: [[String : [[String : String]]]]
}
