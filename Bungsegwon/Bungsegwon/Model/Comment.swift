//
//  Comment.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/26.
//

import Foundation

struct CommentId {
  let id: String
  var comments: [Comment]
}

struct Comment {
  let id: String
  let uid: String
  let name: String
  let comment: String
  let createdDate: String
}
