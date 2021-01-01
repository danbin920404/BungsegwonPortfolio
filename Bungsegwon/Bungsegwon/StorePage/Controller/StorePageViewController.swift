//
//  StorePageViewController.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/23.
//

import UIKit

class StorePageViewController: UIViewController {
  // MARK: - Properties
  private let storePageTopView = StorePageTopView()
  private let storePageView = StorePageView()

  var getData: GetStore!
  private var isIndi = false
  var comments: CommentId!
  private var commentStr = ""
  
  // MARK: - View LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    print(StoreShared.shared.getStores)
    self.setUI()
    self.setLayout()
    self.getComments()
    self.setKeyboard()
  }
  
  // MARK: - SetUI
  private func setUI() {
    self.navigationController?.isNavigationBarHidden = true
    self.view.backgroundColor = .white
    
    [
      self.storePageView,
      self.storePageTopView
    ].forEach {
      self.view.addSubview($0)
    }
    
    self.storePageTopView.dismissBtn.addTarget(
      self,
      action: #selector(self.dismissDidTapBtn),
      for: .touchUpInside
    )
    
    self.storePageView.tableView.contentInsetAdjustmentBehavior = .never
    self.storePageView.tableView.separatorStyle = .none
    self.storePageView.tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    self.storePageView.tableView.delegate = self
    self.storePageView.tableView.dataSource = self
    self.storePageView.tableView.register(
      MainTableViewCell.self,
      forCellReuseIdentifier: MainTableViewCell.identifier
    )
    self.storePageView.tableView.register(
      MenusTableViewCell.self,
      forCellReuseIdentifier: MenusTableViewCell.identifier
    )
    self.storePageView.tableView.register(
      DescriptionTableViewCell.self,
      forCellReuseIdentifier: DescriptionTableViewCell.identifier
    )
    self.storePageView.tableView.register(
      CommentsTableViewCell.self,
      forCellReuseIdentifier: CommentsTableViewCell.identifier
    )
    self.storePageView.tableView.register(
      CommentsNetworkTableViewCell.self,
      forCellReuseIdentifier: CommentsNetworkTableViewCell.identifier
    )
    
  }
  
  // MARK: - SetLayout
  private func setLayout() {
    self.storePageTopView.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(0)
    }
    
    self.storePageView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
    }
  }
  
  // MARK: - Func
  // 어디선가 self를 리로드 시키는 함수 ex) 로그인을 다시 했을 때 데이터를 가져와야 함
  func reloadVC() {
    self.storePageView.tableView.reloadSections(IndexSet(0...0), with: .none)
  }
  
  // 내가 찜한 가게인지 확인하는 함수
  private func checkStoreLike() -> Bool {
    for i in 0 ..< StoreShared.shared.likeStore.count {
      if StoreShared.shared.likeStore[i].id == self.getData.id {
        
        for n in 0 ..< StoreShared.shared.getStores.count {
          if StoreShared.shared.getStores[n].id == self.getData.id {
            StoreShared.shared.getStores[n].isLike = true
            self.getData.isLike = true
            return true
          }
        }
        
      }
    }
    
    return false
  }
  
  private func commentService() {
    if self.commentStr.isEmpty {
      
      self.alertPresent()
    } else {
      
      CreatedCommentFireStoreService.createdComment(
        storeId: self.getData.id,
        comment: self.commentStr,
        mainMenu: self.getData.mainMenu
      )
      
      self.setLocalComment()
      
      NotificationCenter.default.post(
        name: NSNotification.Name("textFieldReset"),
        object: nil
      )
    }
  }
  
  private func alertPresent() {
    let alert = UIAlertController(
      title: "글자가 없어요",
      message: "글자를 입력해주세요.",
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
  
  private func getComments() {
    GetStoreCommentsFirestoreService.getCommentsData(storeId: self.getData.id) { (querySnapshot) in
      guard let querySnapshot = querySnapshot else { return }
      var comments = [Comment]()
      
      for document in querySnapshot.documents {
        let data = document.data()
        let comment = Comment(
          id: data["id"] as! String,
          uid: data["uid"] as! String,
          name: data["name"] as! String,
          comment: data["comment"] as! String,
          createdDate: data["created_at"] as! String
        )
        comments.append(comment)
      }
      
      let commentId = CommentId(
        id: self.getData.id,
        comments: comments
      )
      
      self.comments = commentId

      StoreShared.shared.commentsId.append(commentId)
      
      let sectionCount = self.getData.menus.count + 2
      
      self.isIndi = true
      self.storePageView.tableView.reloadSections(
        IndexSet(sectionCount - 1...sectionCount),
        with: .none
      )
    }
  }
  
  
  // 키보드 셋팅
  private func setKeyboard() {
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    
    let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.keyboardWillShowHide))
    singleTapGestureRecognizer.numberOfTapsRequired = 1
    singleTapGestureRecognizer.isEnabled = true
    singleTapGestureRecognizer.cancelsTouchesInView = false
    self.storePageView.tableView.addGestureRecognizer(singleTapGestureRecognizer)
    
  }
  
  // MARK: - Action Button
  // 화면을 터치하면 키보드를 내리는 함수
  @objc private func keyboardWillShowHide(sender: UITapGestureRecognizer) {
    
    self.view.endEditing(true)
  }
  @objc func keyboardWillShow(_ notification:Notification) {
    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
      self.storePageView.tableView.contentInset = UIEdgeInsets(
        top: 0,
        left: 0,
        bottom: keyboardSize.height,
        right: 0
      )
    }
  }
  @objc func keyboardWillHide(_ notification:Notification) {
    
    if let _ = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
      self.storePageView.tableView.contentInset = .zero
    }
  }
  
  // 댓글 등록할 때 로그인이 안돼있으면 회원가입 페이지로
  @objc private func commentCompletedDidTapBtn(_ sender: UIButton) {
    let isLogin = UserDefaults.standard.value(forKey: "isLogin") as! Bool
      
    if isLogin {
      
      self.commentService()
    } else {
      let mainSingUpVC = MainSingUpViewController()
      
      mainSingUpVC.modalPresentationStyle = .fullScreen
      mainSingUpVC.delegate = self
      mainSingUpVC.getData = self.getData
      self.present(mainSingUpVC, animated: true, completion: nil)
    }
  }
  
  private func setLocalComment() {
    let uid = UserDefaults.standard.value(forKey: "uid") as! String
    let nickName = UserDefaults.standard.value(forKey: "nickName") as! String
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.dateFormat = "yyyy.MM.dd"
    let nowDateStr = formatter.string(from: Date())
    let comment = Comment(
      id: self.getData.id,
      uid: uid,
      name: nickName,
      comment: self.commentStr,
      createdDate: nowDateStr
    )
    
    for i in 0 ..< StoreShared.shared.commentsId.count {
      if StoreShared.shared.commentsId[i].id == self.comments.id {
        StoreShared.shared.commentsId[i].comments.append(comment)
        break
      }
    }
    
    self.comments.comments.append(comment)
    
    let sectionCount = self.getData.menus.count + 2
    
    self.isIndi = true
    self.storePageView.tableView.reloadSections(
      IndexSet(sectionCount - 1...sectionCount),
      with: .none
    )
    
    self.commentStr = ""
  }
  
  @objc private func dismissDidTapBtn(_ sender: UIButton) {
    
    self.navigationController?.popViewController(animated: true)
  }
  
  deinit {
    print("deinit - StorePageViewController")
  }
}

// MARK: - UITableViewDataSource Extension

extension StorePageViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    
    return self.getData.menus.count + 3
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      return 1
    } else if section == self.getData.menus.count + 1 {
      return 1
    } else if section == self.getData.menus.count + 2 {
      if self.isIndi {
        return self.comments.comments.count == 0 ? 0 : self.comments.comments.count
      } else {
        return 1
      }
    }
    let count = section - 1
    let key = self.getData.menus[count].first!.key
    
    return self.getData.menus[count][key]!.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // 섹션 0
    if indexPath.section == 0 {
      let cell = tableView.dequeueReusableCell(
        withIdentifier: MainTableViewCell.identifier,
        for: indexPath
      ) as! MainTableViewCell
      
      cell.configure(
        coord: self.getData.naverLatLng,
        mainImageName: self.getData.mainMenu,
        storeName: self.getData.name,
        createdDate: self.getData.createdDate,
        createdName: self.getData.creator,
        isLike: self.checkStoreLike()
      )
      cell.delegate = self
      cell.selectionStyle = .none
      cell.dismissBtn.addTarget(
        self,
        action: #selector(self.dismissDidTapBtn),
        for: .touchUpInside
      )
      
      return cell
      // 주소, 상세설명
    } else if indexPath.section == self.getData.menus.count + 1 {
      let cell = tableView.dequeueReusableCell(
        withIdentifier: DescriptionTableViewCell.identifier,
        for: indexPath
      ) as! DescriptionTableViewCell
      
      cell.configure(
        address: self.getData.address,
        detailAddress: self.getData.detailAddress,
        description: self.getData.description
      )
      cell.selectionStyle = .none
      
      return cell
      // 댓글
    } else if indexPath.section == self.getData.menus.count + 2 {
      // 댓글 데이터를 받아오기 전까지는 false로 설정해서 indi를 띄워준다
      if self.isIndi {
        let cell = tableView.dequeueReusableCell(
          withIdentifier: CommentsTableViewCell.identifier,
          for: indexPath
        ) as! CommentsTableViewCell
        
        cell.configuer(
          name: self.comments.comments[indexPath.row].name,
          createdDate: self.comments.comments[indexPath.row].createdDate,
          comment: self.comments.comments[indexPath.row].comment
        )
        cell.selectionStyle = .none
        return cell
      } else {
        let cell = tableView.dequeueReusableCell(
          withIdentifier: CommentsNetworkTableViewCell.identifier,
          for: indexPath
        ) as! CommentsNetworkTableViewCell
        
        cell.indicatorView.startAnimating()
        cell.selectionStyle = .none
        return cell
      }
    }
    // 메뉴들
    let cell = tableView.dequeueReusableCell(
      withIdentifier: MenusTableViewCell.identifier,
      for: indexPath
    ) as! MenusTableViewCell
    
    let count = indexPath.section - 1
    let row = indexPath.row
    let key = self.getData.menus[count].first!.key
    let menuTitle = self.getData.menus[count][key]![row].first!.key
    let menuInfo = self.getData.menus[count][key]![row].first!.value
    
    cell.configure(menuTitle: menuTitle, menuInfo: menuInfo)
    cell.selectionStyle = .none
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    if section == 0 {
      return nil
    } else if section == 1 {
      let mainHeaderView = MainHeaderView()
      mainHeaderView.configure(titleName: self.getData.mainMenu)
      
      return mainHeaderView
    } else if section == self.getData.menus.count + 1 {
      
      return nil
    } else if section == self.getData.menus.count + 2 {
      let headerView = CommentsHeaderView()
      
      if isIndi {
        headerView.configuer(count: self.comments.comments.count)
      }
      
      return headerView
    }
    let menusHeaderView = MenusHeaderView()
    let count = section - 1
    let titleName = self.getData.menus[count].first!.key
    
    menusHeaderView.configure(titleName: titleName)
    
    return menusHeaderView
  }
  
  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    if section == self.getData.menus.count + 2 {
      let commentsFooterView = CommentsFooterView()
      commentsFooterView.textField.delegate = self
      commentsFooterView.registerBtn.addTarget(
        self,
        action: #selector(self.commentCompletedDidTapBtn),
        for: .touchUpInside
      )
      
      return commentsFooterView
    }
    
    return nil
  }
}

extension StorePageViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if section == 0 {
      return CGFloat.leastNormalMagnitude
    } else if section == self.getData.menus.count + 1 {
      return CGFloat.leastNormalMagnitude
    }
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    if section == self.getData.menus.count + 2 {
      return UITableView.automaticDimension
    }
    
    return CGFloat.leastNormalMagnitude
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView.contentOffset.y > UIScreen.main.bounds.width / 1.2 {
      if self.storePageTopView.frame.height == 0 {
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn) {
          self.storePageTopView.snp.updateConstraints {
            $0.height.equalTo(100)
          }
          self.view.layoutIfNeeded()
        }
      }
    } else {
      if self.storePageTopView.frame.height == 100 {
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut) {
          self.storePageTopView.snp.updateConstraints {
            $0.height.equalTo(0)
          }
          self.view.layoutIfNeeded()
        }
      }
    }
  }
}

// MARK: - 찜, 수정 버튼 함수
// MARK: - MainTableViewCellDelegate Extension
extension StorePageViewController: MainTableViewCellDelegate {
  // 수정
  func modifyDidTapBtn() {
    let isLogin = UserDefaults.standard.value(forKey: "isLogin") as! Bool
    // 로그인을 안했다면 회원가입 화면으로 이동
    if isLogin == false {
      let mainSingUpVC = MainSingUpViewController()
      
      mainSingUpVC.modalPresentationStyle = .fullScreen
      mainSingUpVC.delegate = self
      mainSingUpVC.getData = self.getData
      self.present(mainSingUpVC, animated: true, completion: nil)
    }
    let reportVC = ReportViewController()
    
    for i in 0 ..< self.getData.menus.count {
      
      let key = self.getData.menus[i].first?.key
      let value = self.getData.menus[i].first?.value
      let sectionCount = MenuStrArr.menuStrArr.firstIndex(of: key!)
      let cellCount = value?.count
      let collectionCount = CollectionCount(sectionCount: sectionCount!, cellCount: cellCount!)
      reportVC.selectedMenu.append(collectionCount)
      
      var textFieldStorages: [TextFieldStorage] = []
      for n in 0 ..< value!.count {
        
        let firstText = value![n].first!.key
        let secondText = value![n].first!.value
        let textFieldStorage = TextFieldStorage(firstText: firstText, secondText: secondText)
        textFieldStorages.append(textFieldStorage)
      }
      reportVC.textfieldStorage.append(textFieldStorages)
    }
    
    reportVC.storeInfo.storeNameStr = self.getData.name
    reportVC.storeInfo.addressStr = self.getData.address
    reportVC.storeInfo.detailAddressStr = self.getData.detailAddress
    reportVC.storeInfo.descriptionStr = self.getData.description
    reportVC.storeInfo.latitude = self.getData.naverLatLng.lat
    reportVC.storeInfo.longitude = self.getData.naverLatLng.lng
    reportVC.storeId = self.getData.id
    
    
    let navi = UINavigationController(rootViewController: reportVC)
    navi.modalPresentationStyle = .fullScreen
    self.present(navi, animated: true, completion: nil)
  }
  
  // 찜
  func likeDidTapBtn() -> Bool {
    let isLogin = UserDefaults.standard.value(forKey: "isLogin") as! Bool
    
    // 로그인을 안했다면 회원가입 화면으로 이동
    if isLogin == false {
      let mainSingUpVC = MainSingUpViewController()
      
      mainSingUpVC.modalPresentationStyle = .fullScreen
      mainSingUpVC.delegate = self
      mainSingUpVC.getData = self.getData
      self.present(mainSingUpVC, animated: true, completion: nil)
      
      return false
    }
    for i in 0 ..< StoreShared.shared.getStores.count {
      if StoreShared.shared.getStores[i].id == self.getData.id {
        
      }
    }
    
    LikeFireStoreSerVice.LikeFireStoreSerVice(
      storeId: getData.id,
      address: getData.address,
      mainMenu: getData.mainMenu
    )
    
    for i in 0 ..< StoreShared.shared.getStores.count {
      if StoreShared.shared.getStores[i].id == self.getData.id {
        
        StoreShared.shared.getStores[i].isLike = !StoreShared.shared.getStores[i].isLike
        
        // StoreShared.shared.likeStores에 추가 및 삭제
        if StoreShared.shared.getStores[i].isLike {
          let likeStore = LikeStore(
            id: getData.id,
            address: getData.address,
            mainMenu: getData.mainMenu
          )
          StoreShared.shared.likeStore.insert(likeStore, at: 0)
          print("추가",StoreShared.shared.likeStore)
        } else {
          for i in 0 ..< StoreShared.shared.likeStore.count {
            if StoreShared.shared.likeStore[i].id == self.getData.id {
              StoreShared.shared.likeStore.remove(at: i)
              print("삭제", StoreShared.shared.likeStore)
              return true
            }
          }
        }
        
        return true
      }
    }
    
    return true
  }
  
}

// MARK: - MainSingUpViewControllerDelegate Extension
extension StorePageViewController: MainSingUpViewControllerDelegate {
  // 타이틀 이미지를 보였다가 사라지게 할 불값 전달
  func titleImageViewIsHidden() -> Bool {
    return true
  }
}

// MARK: - UITextFieldDelegate Extension
// 텍스트필드를 클릭했을 때 로그인이 안돼있으면 회원가입 페이지로 이동
extension StorePageViewController: UITextFieldDelegate {
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    let isLogin = UserDefaults.standard.value(forKey: "isLogin") as! Bool
    
    if isLogin {
      
      return true
    } else {
      let mainSingUpVC = MainSingUpViewController()
      
      mainSingUpVC.modalPresentationStyle = .fullScreen
      mainSingUpVC.delegate = self
      mainSingUpVC.getData = self.getData
      self.present(mainSingUpVC, animated: true, completion: nil)
      
      return false
    }
  }
  
  func textFieldDidChangeSelection(_ textField: UITextField) {
    guard let text = textField.text else { return }
    
    self.commentStr = text
  }
}
