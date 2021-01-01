//
//  MyPageViewController.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/22.
//

import UIKit

class MyPageViewController: UIViewController {
  // MARK: - Properties
  private let contentsView = UIView()
  private let myPageTopView = MyPageTopView()
  private let mypageContentsView = MypageContentsView()
  private var createdStores = [[String: String]]()
  private var myComments = [[String: String]]()
  
  // MARK: - View LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    print("viewDidLoad - MyPageViewController")
    self.setUI()
    self.setLayout()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    guard let isLogin = UserDefaults.standard.value(forKey: "isLogin") as? Bool else {
      return
    }
    
    if isLogin {
      guard let nickName = UserDefaults.standard.value(forKey: "nickName") as? String else {
        return print("유저디폴트에 닉네임이 없음 - MyPageViewController")
      }
      self.myPageTopView.setTitleLabel(titleStr: "안녕하세요\n\(nickName)님")
    } else {
      self.myPageTopView.setTitleLabel(titleStr: "로그인이\n필요해요")
    }
    
    self.mypageContentsView.favoriteCollectionView.reloadData()
    self.mypageContentsView.registerCollectionView.reloadData()
    self.mypageContentsView.commentTableView.reloadData()
  }
  
  
  
  // MARK: - SetUI
  private func setUI() {
    self.navigationController?.isNavigationBarHidden = true
    self.tabBarController?.tabBar.tintColor = .white
    self.tabBarController?.tabBar.isTranslucent = false
    
    self.view.addSubview(self.contentsView)
    
    [
      self.mypageContentsView,
      self.myPageTopView
    ].forEach {
      self.contentsView.addSubview($0)
    }
    
    self.view.backgroundColor = UIColor(
      red: 1,
      green: 0.831,
      blue: 0.392,
      alpha: 1
    )
    
    self.contentsView.backgroundColor = UIColor(
      red: 0.957,
      green: 0.957,
      blue: 0.957,
      alpha: 1
    )
    
    self.myPageTopView.settingsBtn.addTarget(
      self,
      action: #selector(self.settingDidTapBtn),
      for: .touchUpInside
    )
    
    let topTitleLabelGesture = UITapGestureRecognizer(
      target: self,
      action: #selector(self.topTitleDidTapGesture)
    )
    self.myPageTopView.titleLabel.isUserInteractionEnabled = true
    self.myPageTopView.titleLabel.addGestureRecognizer(topTitleLabelGesture)
    
    self.mypageContentsView.favoriteCollectionView.delegate = self
    self.mypageContentsView.favoriteCollectionView.dataSource = self
    self.mypageContentsView.favoriteCollectionView.register(
      MyPageMainCollectionViewCell.self,
      forCellWithReuseIdentifier: MyPageMainCollectionViewCell.identifier
    )
    self.mypageContentsView.favoriteCollectionView.register(
      MyPageMainNoneCollectionViewCell.self,
      forCellWithReuseIdentifier: MyPageMainNoneCollectionViewCell.identifier
    )
    
    self.mypageContentsView.registerCollectionView.delegate = self
    self.mypageContentsView.registerCollectionView.dataSource = self
    self.mypageContentsView.registerCollectionView.register(
      MyPageMainCollectionViewCell.self,
      forCellWithReuseIdentifier: MyPageMainCollectionViewCell.identifier
    )
    self.mypageContentsView.registerCollectionView.register(
      MyPageMainNoneCollectionViewCell.self,
      forCellWithReuseIdentifier: MyPageMainNoneCollectionViewCell.identifier
    )
    
    self.mypageContentsView.commentTableView.delegate = self
    self.mypageContentsView.commentTableView.dataSource = self
    self.mypageContentsView.commentTableView.register(
      MyPageMainTableViewCell.self,
      forCellReuseIdentifier: MyPageMainTableViewCell.identifier
    )
    self.mypageContentsView.commentTableView.register(
      MyPageNoneTableViewCell.self,
      forCellReuseIdentifier: MyPageNoneTableViewCell.identifier
    )
    
    self.mypageContentsView.registerCVTilteView.delegate = self
    self.mypageContentsView.favoriteCVTitleView.delegate = self
    self.mypageContentsView.commentTilteView.delegate = self
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.reloadViewController),
      name: NSNotification.Name("ReloadVC"),
      object: nil
    )
  }
  
  override func viewDidAppear(_ animated: Bool) {
    let label = UILabel()
    label.font = UIFont(
      name: "AppleSDGothicNeo-Bold",
      size: 14
    )
    let height = ("text" as NSString)
      .size(withAttributes: [NSAttributedString.Key.font : label.font as Any]).height
    
    // 셀 컨텐츠들의 top, bottom 여백과 위아래 마진의 합은 40 + sectionInset에 top + bottom
    self.mypageContentsView.favoriteCollectionView.snp.updateConstraints {
      $0.height.equalTo(
        (height * 2)
          + 41
          + MyPageCollectionLayout.sectionInset.top
          + MyPageCollectionLayout.sectionInset.bottom
      )
    }
    // 셀 컨텐츠들의 top, bottom 여백과 위아래 마진의 합은 40 + sectionInset에 top + bottom
    self.mypageContentsView.registerCollectionView.snp.updateConstraints {
      $0.height.equalTo(
        (height * 2)
          + 41
          + MyPageCollectionLayout.sectionInset.top
          + MyPageCollectionLayout.sectionInset.bottom
      )
    }
  }
  
  // MARK: - SetLayout
  private func setLayout() {
    self.contentsView.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
    }
    
    self.myPageTopView.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
      $0.leading.trailing.equalToSuperview()
    }
    
    self.mypageContentsView.snp.makeConstraints {
      $0.top.equalTo(self.myPageTopView.snp.bottom)
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
    }
  }
  
  // MARK: - Func
  
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
  @objc private func settingDidTapBtn(_ sender: UIButton) {
    let settingsVC = SettingsViewController()
    
    self.navigationController?.pushViewController(settingsVC, animated: true)
  }
  
  @objc private func topTitleDidTapGesture(_ gesture: UIGestureRecognizer) {
    guard let islogin = UserDefaults.standard.value(forKey: "isLogin") as? Bool else {
      return print("유저디폴트에 isLogin값이 없음 - MyPageViewController")
    }
    
    if islogin {
      let editMyInfoVC = EditMyInfoViewController()
      
      self.navigationController?.pushViewController(editMyInfoVC, animated: true)
    } else {
      let mainSingUpVC = MainSingUpViewController()
      
      mainSingUpVC.modalPresentationStyle = .fullScreen
      mainSingUpVC.delegate = self
      self.present(mainSingUpVC, animated: true, completion: nil)
    }
  }
  
  // 어디선가 self를 리로드 시키는 함수 ex) 로그인을 다시 했을 때 데이터를 가져와야 함
  @objc private func reloadViewController() {
    //    self.mypageContentsView.favoriteCollectionView.reloadData()
  }
}

// MARK: - MainSingUpVC에 타이틀 이미지를 보여줄지 말지 결정
extension MyPageViewController: MainSingUpViewControllerDelegate {
  func titleImageViewIsHidden() -> Bool {
    return true
  }
}

// MARK: - CategoryTitleViewDelegate Extension
extension MyPageViewController: CategoryTitleViewDelegate {
  func presentVC(_ titleStr: String) {
    let isLogin = UserDefaults.standard.value(forKey: "isLogin") as! Bool
    
    if isLogin {
      let myPageDetailVC = MyPageDetailViewController()
      
      myPageDetailVC.naviTitleStr = titleStr
      myPageDetailVC.hidesBottomBarWhenPushed = true
      self.navigationController?.pushViewController(myPageDetailVC, animated: true)
    } else {
      let mainSingUpVC = MainSingUpViewController()
      
      mainSingUpVC.modalPresentationStyle = .fullScreen
      mainSingUpVC.delegate = self
      self.present(mainSingUpVC, animated: true, completion: nil)
    }
  }
}

// MARK: - UICollectionViewDataSource Extension
extension MyPageViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    let isLogin = UserDefaults.standard.value(forKey: "isLogin") as! Bool
    
    if isLogin {
      switch collectionView {
      // 찜
      case self.mypageContentsView.favoriteCollectionView:
        let dataLike = StoreShared.shared.likeStore
        if dataLike.count == 0 {
          self.mypageContentsView.favoriteCollectionView.isScrollEnabled = false
          return 1
        } else {
          self.mypageContentsView.favoriteCollectionView.isScrollEnabled = true
          return dataLike.count
        }
      // 내가 등록한 가게
      case self.mypageContentsView.registerCollectionView:
        let dataCreatedStore = StoreShared.shared.createdStores
        if dataCreatedStore.count == 0 {
          self.mypageContentsView.registerCollectionView.isScrollEnabled = false
          return 1
        } else {
          self.mypageContentsView.registerCollectionView.isScrollEnabled = true
          return dataCreatedStore.count
        }
      default:
        return 0
      }
    } else {
      // 로그인이 안돼 있을 때 Count
      switch collectionView {
      case self.mypageContentsView.favoriteCollectionView:
        return 1
      case self.mypageContentsView.registerCollectionView:
        return 1
      default:
        return 0
      }
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let isLogin = UserDefaults.standard.value(forKey: "isLogin") as! Bool
    
    if isLogin {
      switch collectionView {
      case self.mypageContentsView.favoriteCollectionView:
        if StoreShared.shared.likeStore.count == 0 {
          self.mypageContentsView.favoriteCollectionView.isScrollEnabled = false
          let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MyPageMainNoneCollectionViewCell.identifier,
            for: indexPath
          ) as! MyPageMainNoneCollectionViewCell
          
          cell.configure(titleStr: "내가 찜한 가게가 없어요.")
          
          return cell
        } else {
          let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MyPageMainCollectionViewCell.identifier,
            for: indexPath
          ) as! MyPageMainCollectionViewCell
          
          let data = StoreShared.shared.likeStore
          cell.configuer(
            imageName: data[indexPath.row].mainMenu,
            address: data[indexPath.row].address
          )
          
          return cell
        }
      case self.mypageContentsView.registerCollectionView:
        if StoreShared.shared.createdStores.count == 0 {
          self.mypageContentsView.registerCollectionView.isScrollEnabled = false
          let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MyPageMainNoneCollectionViewCell.identifier,
            for: indexPath
          ) as! MyPageMainNoneCollectionViewCell
          
          cell.configure(titleStr: "내가 등록한 가게가 없어요.")
          
          return cell
        } else {
          let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MyPageMainCollectionViewCell.identifier,
            for: indexPath
          ) as! MyPageMainCollectionViewCell
          let data = StoreShared.shared.createdStores[indexPath.row]
          
          cell.configuer(
            imageName: data.mainMenu,
            address: data.address
          )
          
          return cell
        }
        
      default:
        return UICollectionViewCell()
      }
      
    } else {
      // 로그인이 안됐을 때
      switch collectionView {
      case self.mypageContentsView.favoriteCollectionView:
        // MARK: - 여기 == 0으로 바꾸기
        if StoreShared.shared.likeStore.count == 0 {
          self.mypageContentsView.favoriteCollectionView.isScrollEnabled = false
          let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MyPageMainNoneCollectionViewCell.identifier,
            for: indexPath
          ) as! MyPageMainNoneCollectionViewCell
          
          cell.configure(titleStr: "내가 찜한 가게가 없어요.")
          
          return cell
        } else {
          let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MyPageMainCollectionViewCell.identifier,
            for: indexPath
          ) as! MyPageMainCollectionViewCell
          
          
          
          return cell
        }
      case self.mypageContentsView.registerCollectionView:
        if self.createdStores.count == 0 {
          self.mypageContentsView.registerCollectionView.isScrollEnabled = false
          let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MyPageMainNoneCollectionViewCell.identifier,
            for: indexPath
          ) as! MyPageMainNoneCollectionViewCell
          
          cell.configure(titleStr: "내가 등록한 가게가 없어요.")
          
          return cell
        } else {
          let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MyPageMainCollectionViewCell.identifier,
            for: indexPath
          ) as! MyPageMainCollectionViewCell
          
          return cell
        }
        
      default:
        return UICollectionViewCell()
      }
    }
    
    
  }
}
struct MyPageCollectionLayout {
  static let cellSpacing: CGFloat = 0
  static let lineSpacing: CGFloat = 8
  static let itemCount: CGFloat = 2.1
  static let sectionInset = UIEdgeInsets(top: 8, left: 16, bottom: 24, right: 16)
}
// MARK: - UICollectionViewDelegateFlowLayout Extension
extension MyPageViewController: UICollectionViewDelegateFlowLayout {
  //지정된 셀의 크기를 반환하는 메서드.
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let contentWidth = collectionView.bounds.width -
      (MyPageCollectionLayout.cellSpacing * (MyPageCollectionLayout.itemCount - 1)) -
      (MyPageCollectionLayout.sectionInset.left + MyPageCollectionLayout.sectionInset.right)
    let cellWidth = contentWidth / MyPageCollectionLayout.itemCount
    let label = UILabel()
    label.font = UIFont(
      name: "AppleSDGothicNeo-Bold",
      size: 14
    )
    let height = ("text" as NSString)
      .size(withAttributes: [NSAttributedString.Key.font : label.font as Any]).height
    
    // 셀 컨텐츠들의 top, bottom 여백과 위아래 마진의 합은 40
    switch collectionView {
    case self.mypageContentsView.favoriteCollectionView:
      if StoreShared.shared.likeStore.count == 0 {
        return CGSize(width: collectionView.frame.width - MyPageCollectionLayout.sectionInset.left - MyPageCollectionLayout.sectionInset.right, height: (height * 2) + 40)
      } else {
        return CGSize(width: cellWidth, height: (height * 2) + 40)
      }
    case self.mypageContentsView.registerCollectionView:
      if StoreShared.shared.createdStores.count == 0 {
        return CGSize(width: collectionView.frame.width - MyPageCollectionLayout.sectionInset.left - MyPageCollectionLayout.sectionInset.right, height: (height * 2) + 40)
      } else {
        return CGSize(width: cellWidth, height: (height * 2) + 40)
      }
    default:
      return .zero
    }
  }
  
  //지정된 섹션의 여백을 반환하는 메서드.
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    
    return MyPageCollectionLayout.sectionInset
  }
  
  // 첫 줄과 두번 째 줄 사이의 거리
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    
    return MyPageCollectionLayout.lineSpacing
  }
  
  // 첫 줄에 셀들의 여백
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    
    return MyPageCollectionLayout.cellSpacing
  }
  
}

// MARK: - UICollectionViewDelegate Extension
extension MyPageViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    var storeId = ""
    switch collectionView {
    case self.mypageContentsView.favoriteCollectionView:
      storeId = StoreShared.shared.likeStore[indexPath.item].id
    case self.mypageContentsView.registerCollectionView:
      storeId = StoreShared.shared.createdStores[indexPath.item].id
    default:
      break
    }
    
    // 네트워크 통신할 동안 인디 present
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
  
  
  
  func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
    let isLogin = UserDefaults.standard.value(forKey: "isLogin") as! Bool
    
    if isLogin {
      switch collectionView {
      case self.mypageContentsView.favoriteCollectionView:
        return StoreShared.shared.likeStore.count == 0 ? false : true
      case self.mypageContentsView.registerCollectionView:
        return StoreShared.shared.createdStores.count == 0 ? false : true
      default:
        return false
      }
    } else {
      return false
    }
  }
}

// MARK: - UITableViewDataSource Extension
extension MyPageViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let isLogin = UserDefaults.standard.value(forKey: "isLogin") as! Bool
    
    if isLogin {
      if UIScreen.main.bounds.height < 668 {
        return 1
      } else {
        return StoreShared.shared.myComments.count == 0 ? 1 :
          StoreShared.shared.myComments.count >= 2 ? 2 : 1
      }
    }
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let isLogin = UserDefaults.standard.value(forKey: "isLogin") as! Bool
    
    if isLogin == false {
      let cell = tableView.dequeueReusableCell(
        withIdentifier: MyPageNoneTableViewCell.identifier,
        for: indexPath
      ) as! MyPageNoneTableViewCell
      
      return cell
    }
    
    if StoreShared.shared.myComments.count == 0 {
      let cell = tableView.dequeueReusableCell(
        withIdentifier: MyPageNoneTableViewCell.identifier,
        for: indexPath
      ) as! MyPageNoneTableViewCell
      
      return cell
    } else {
      let cell = tableView.dequeueReusableCell(
        withIdentifier: MyPageMainTableViewCell.identifier,
        for: indexPath
      ) as! MyPageMainTableViewCell
      
      let data = StoreShared.shared.myComments[indexPath.row]
      
      cell.configuer(
        mainMenu: data.mainMenu,
        comment: data.comment,
        createdDate: data.createdDate
      )
      
      return cell
    }
  }
}

// MARK: - UITableViewDelegate Extension
extension MyPageViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // 네트워크 통신할 동안 인디 present
    let storeId = StoreShared.shared.myComments[indexPath.row].id
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
  
  func tableView(_ tableView: UITableView,
                 shouldHighlightRowAt indexPath: IndexPath) -> Bool {
    let isLogin = UserDefaults.standard.value(forKey: "isLogin") as! Bool
    
    if isLogin {
      return StoreShared.shared.myComments.count == 0 ? false : true
    }
    return false
  }
}
