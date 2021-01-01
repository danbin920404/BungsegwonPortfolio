//
//  DataShared.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/25.
//

import Foundation

class StoreShared {
  static let shared = StoreShared()
  
  private init() { }
  
  var mapInfos = [MapInfo]()
  var getStores = [GetStore]()
  var likeStore = [LikeStore]()
  var commentsId = [CommentId]()
  var createdStores = [CreatedStore]()
  var myComments = [MyComment]()
}
