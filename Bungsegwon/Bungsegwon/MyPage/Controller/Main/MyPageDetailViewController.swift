//
//  MyPageDetailViewController.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/22.
//

import UIKit

class MyPageDetailViewController: UIViewController {
  // MARK: - Properties
  private lazy var myPageDetailTopView = MyPageDetailTopView(
    frame: .zero,
    titleStr: self.naviTitleStr
  )
  var naviTitleStr = ""
  private let myPageDetatilContentsView = MyPageDetatilContentsView()
  
  // MARK: - View LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.setUI()
    self.setLayout()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    print(StoreShared.shared.createdStores)
//    print(StoreShared.shared.myComments)
//    print(StoreShared.shared.myComments.count)
  }
  
  // MARK: - SetUI
  private func setUI() {
    [
      self.myPageDetatilContentsView,
      self.myPageDetailTopView
    ].forEach {
      self.view.addSubview($0)
    }
    
    self.view.backgroundColor = .white
    
    self.myPageDetailTopView.delegate = self
    
    self.myPageDetatilContentsView.detailTableView.delegate = self
    self.myPageDetatilContentsView.detailTableView.dataSource = self
    self.myPageDetatilContentsView.detailTableView.register(
      MyPageDetailTableViewCell.self,
      forCellReuseIdentifier: MyPageDetailTableViewCell.identifier
    )
    self.myPageDetatilContentsView.detailTableView.register(
      MyPageDetailCommentTableViewCell.self,
      forCellReuseIdentifier: MyPageDetailCommentTableViewCell.identifier
    )
  }
  
  // MARK: - SetLayout
  private func setLayout() {
    self.myPageDetailTopView.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
      $0.leading.trailing.equalToSuperview()
    }
    
    self.myPageDetatilContentsView.snp.makeConstraints {
      $0.top.equalTo(self.myPageDetailTopView.snp.bottom)
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
    }
  }
  
  // MARK: - Func
  private func checkDataId(indexPath: IndexPath) -> String {
    let row = indexPath.row
    
    switch self.naviTitleStr {
    case "내가 찜한 가게":
      return StoreShared.shared.likeStore[row].id
    case "내가 등록한 가게":
      return StoreShared.shared.createdStores[row].id
    case "내가 쓴 댓글":
      return StoreShared.shared.myComments[row].id
    default:
      break
    }
    
    return ""
  }
  
  // 찜이거나 내가 쓴 댓글이 삭제됐을 경우 해당하는 가게에 정보를 가져올 수 없어서 얼럿창을 뜨ㅟ어줌
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
  
  // MARK: - Action Button
  @objc private func deleteDidTapbtn(_ sender: UIButton) {
    if self.naviTitleStr == "내가 찜한 가게" {
      self.likeDelete(index: sender.tag)
    } else if self.naviTitleStr == "내가 쓴 댓글" {
      self.myCommentDelete(index: sender.tag)
    } else if self.naviTitleStr == "내가 등록한 가게" {
      self.storeDelete(index: sender.tag)
    }
  }
  
  //------------ 내가 등록한 가게 삭제 함수 -------------
  private func storeDelete(index: Int) {
    let storeId = StoreShared.shared.createdStores[index].id
    print(1)
    // 로컬에 있는 데이터를 지움 - 1
    StoreShared.shared.createdStores.remove(at: index)
    
    // 로컬에 상페페이지를 열어봤다면 삭제 - 2
    for i in 0 ..< StoreShared.shared.getStores.count {
      if StoreShared.shared.getStores[i].id == storeId {
        StoreShared.shared.getStores.remove(at: i)
        print(2)
        break
      }
    }
    print(3)
    // 맵에 표현되는 마커 지우라고 Post를 보냄 - 3
    NotificationCenter.default.post(
      name: NSNotification.Name("deleteMarker"),
      object: nil,
      userInfo: ["deleteMarker": storeId]
    )
    print(4)
    // 서버에서 삭제 - 4
    DeleteStoreService.deleteStore(storeId: storeId)
    
    // 테이블 셀을 지워준다 - 3
    self.myPageDetatilContentsView.detailTableView.deleteRows(
      at: [IndexPath(row: index, section: 0)],
      with: .middle
    )
    
    self.myPageDetatilContentsView.detailTableView.reloadData()
  }
  
  //------------ 내가 쓴 댓글 삭제 함수 --------------
  private func myCommentDelete(index: Int) {
    let storeId = StoreShared.shared.myComments[index].id
    let comment = StoreShared.shared.myComments[index].comment

    // 로컬에 있는 commentsId를 삭제해준다 - 1
    self.deleteCommentsId(storeId: storeId, comment: comment)
    
    // 로컬에 있는 데이터를 지움 - 2
    StoreShared.shared.myComments.remove(at: index)
    
    // 테이블 셀을 지워준다 - 3
    self.myPageDetatilContentsView.detailTableView.deleteRows(
      at: [IndexPath(row: index, section: 0)],
      with: .middle
    )
    
    self.myPageDetatilContentsView.detailTableView.reloadData()
    
    // 서버에 내가 쓴 댓글 삭제 - 4
    DeleteMyCommentService.deleteMyCommnet(storeId: storeId, comment: comment)
  }
  
  private func deleteCommentsId(storeId: String, comment: String) {
    for i in 0 ..< StoreShared.shared.commentsId.count {
      if StoreShared.shared.commentsId[i].id == storeId {
        for n in 0 ..< StoreShared.shared.commentsId[i].comments.count {
          if StoreShared.shared.commentsId[i].comments[n].comment == comment {
            StoreShared.shared.commentsId.remove(at: i)
            return
          }
        }
      }
    }
  }
  
  //---------- 내가 찜한 가게 삭제 함수 ------------
  private func likeDelete(index: Int) {
    let storeId = StoreShared.shared.likeStore[index].id
    // 로걸에 있는 데이터를 지움 - 1
    StoreShared.shared.likeStore.remove(at: index)
    
    // 로걸에 있는 getStroe에 isLike를 false로 해줌 - 2
    for i in 0 ..< StoreShared.shared.getStores.count {
      if StoreShared.shared.getStores[i].id == storeId {
        StoreShared.shared.getStores[i].isLike = false
        break
      }
    }
    
    // 테이블 셀을 지워준다 - 3
    self.myPageDetatilContentsView.detailTableView.deleteRows(
      at: [IndexPath(row: index, section: 0)],
      with: .middle
    )
    
    self.myPageDetatilContentsView.detailTableView.reloadData()
    
    // 서버에 있는 데이터 삭제
    DeleteLikeStoreService.deleteLike(storeId: storeId)
  }
  
  deinit {
    print("deinit - MyPageDetailViewController")
  }
}

// MARK: - MyPageDetailTopViewDelegate Extension
extension MyPageDetailViewController:  MyPageDetailTopViewDelegate {
  func dismissVC() {
    self.myPageDetailTopView.delegate = nil
    
    self.navigationController?.popViewController(animated: true)
  }
}

// MARK: - UITableViewDataSource Extension
extension MyPageDetailViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch self.naviTitleStr {
    case "내가 찜한 가게":
      return StoreShared.shared.likeStore.count
    case "내가 등록한 가게":
      return StoreShared.shared.createdStores.count
    case "내가 쓴 댓글":
      return StoreShared.shared.myComments.count
    default:
      return 0
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if self.naviTitleStr == "내가 쓴 댓글" {
      let cell = tableView.dequeueReusableCell(
        withIdentifier: MyPageDetailCommentTableViewCell.identifier,
        for: indexPath
      ) as! MyPageDetailCommentTableViewCell
      
      let data = self.checkData(indexPath: indexPath)
      
      cell.deleteBtn.addTarget(
        self,
        action: #selector(self.deleteDidTapbtn),
        for: .touchUpInside
      )
      cell.deleteBtn.tag = indexPath.row
      cell.configuer(
        mainMenu: data[0],
        comment: data[1],
        createdDate: data[2]
      )
      
      return cell
    }
    
    let cell = tableView.dequeueReusableCell(
      withIdentifier: MyPageDetailTableViewCell.identifier,
      for: indexPath
    ) as! MyPageDetailTableViewCell
    
    let data = self.checkData(indexPath: indexPath)
    
    cell.configuer(imageName: data[0], address: data[1])
    cell.deleteBtn.tag = indexPath.row
    cell.deleteBtn.addTarget(
      self,
      action: #selector(self.deleteDidTapbtn),
      for: .touchUpInside
    )
    
    return cell
  }
  
  private func checkData(indexPath: IndexPath) -> [String] {
    let row = indexPath.row
    var data: [String] = []
    
    switch self.naviTitleStr {
    case "내가 찜한 가게":
      data.append(StoreShared.shared.likeStore[row].mainMenu)
      data.append(StoreShared.shared.likeStore[row].address)
    case "내가 등록한 가게":
      data.append(StoreShared.shared.createdStores[row].mainMenu)
      data.append(StoreShared.shared.createdStores[row].address)
    case "내가 쓴 댓글":
      data.append(StoreShared.shared.myComments[row].mainMenu)
      data.append(StoreShared.shared.myComments[row].comment)
      data.append(StoreShared.shared.myComments[row].createdDate)
    default:
      break
    }
    
    return data
  }
}

// MARK: - UITableViewDelegate Extension
extension MyPageDetailViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // 네트워크 통신할 동안 인디 present
    let storeId = self.checkDataId(indexPath: indexPath)
    let indiVC = IndicatorViewController()
    
    indiVC.modalPresentationStyle = .overFullScreen
    self.present(indiVC, animated: false, completion: nil)
    // 이미 가져온 데이터가 있는지 확인 후 없다면 네트워크 통신을 한다
    let getStoreFireStoreService = GetStoreFireStoreService()
    getStoreFireStoreService.getStore(storeId: storeId, completionHandler: { data in
      if data == nil {
        indiVC.isDismiss = true
        
        self.noneStoreAlert()
      } else {
        let storeVC = StorePageViewController()
        
        storeVC.getData = data
        storeVC.hidesBottomBarWhenPushed = true
        // 네트워크 통신이 끝나면 indi Dismiss
        indiVC.isDismiss = true
        self.navigationController?.pushViewController(storeVC, animated: true)
      }
    })
  }
}
