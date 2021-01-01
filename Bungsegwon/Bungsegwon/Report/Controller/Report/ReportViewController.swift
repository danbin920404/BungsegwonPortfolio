//
//  ReportViewController.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/22.
//

import UIKit

class ReportViewController: UIViewController {
  // MARK: - Properties
  private let backgroundColorView = UIView()
  private let reportTopNavigationView = ReportTopNavigationView()
  private let reportView = ReportView()
  var selectedMenu: [CollectionCount] = []
  var textfieldStorage: [[TextFieldStorage]] = []
  var storeInfo = StoreInfo(
    storeNameStr: "",
    addressStr: "",
    detailAddressStr: "",
    descriptionStr: "",
    latitude: 0,
    longitude: 0
  )
  private var isPassStore = false
  
  // 수정에서 넘어오면 storeID가 있음
  // 이유는 서버에 저장할 때 storeId에 다시 저장을 해야됨
  var storeId = ""
  
  // MARK: - View LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    print("시작",storeInfo.latitude, storeInfo.longitude)
    self.setUI()
    self.setLayout()
    self.firstSetText()
  }
  
  override func viewDidLayoutSubviews() {
    self.reportView.selectedMenuTableView.snp.updateConstraints {
      $0.height.equalTo(self.reportView.selectedMenuTableView.contentSize.height)
    }

    self
      .reportView
      .scrollView
      .contentSize
      .height = self
      .reportView
      .reportCompleteView
      .frame.maxY
  }
  
  // MARK: - SetUI
  private func setUI() {
    self.view.backgroundColor = .white
    self.navigationController?.isNavigationBarHidden = true
    
    self.backgroundColorView.backgroundColor = UIColor(
      red: 0.957,
      green: 0.957,
      blue: 0.957,
      alpha: 1
    )
    
    [
      self.backgroundColorView,
      self.reportView,
      self.reportTopNavigationView
    ].forEach {
      self.view.addSubview($0)
    }
    
    self.reportTopNavigationView.dismissBtn.addTarget(
      self,
      action: #selector(self.dismissDidTapBtn),
      for: .touchUpInside
    )
    
    self.reportView.reportAddressView.kakaoSearchBtn.addTarget(
      self,
      action: #selector(self.kakaoSearchDidTapBtn),
      for: .touchUpInside
    )
    
    self.reportView.categoryCollectionView.delegate = self
    self.reportView.categoryCollectionView.dataSource = self
    self.reportView.categoryCollectionView.register(
      ReportMenuCVCell.self,
      forCellWithReuseIdentifier: ReportMenuCVCell.identifier
    )
    
    self.reportView.selectedMenuTableView.delegate = self
    self.reportView.selectedMenuTableView.dataSource = self
    self.reportView.selectedMenuTableView.register(
      SelectedMenuTableViewCell.self,
      forCellReuseIdentifier: SelectedMenuTableViewCell.identifier
    )
    
    self.reportView.reportCompleteView.completeBtn.addTarget(
      self,
      action: #selector(self.completeDidTapBtn),
      for: .touchUpInside
    )
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.getDescription),
      name: NSNotification.Name("getDescription"),
      object: nil
    )
    
    // ReportAddressView에서 텍스트필드에 값들을 받아옴
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.passInfoAddress),
      name: NSNotification.Name("passInfoAddress"),
      object: nil
    )
    
    // 키보드 올라올 때
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.keyboardWillShowHide),
      name: UIResponder.keyboardWillShowNotification,
      object: nil
    )
    // 키보드 내려갈 때
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.keyboardWillShowHide),
      name: UIResponder.keyboardWillHideNotification,
      object: nil
    )
  }
  
  // MARK: - SetLayout
  private func setLayout() {
    self.backgroundColorView.snp.makeConstraints {
      $0.top.bottom.equalTo(self.view.safeAreaLayoutGuide)
      $0.leading.trailing.equalToSuperview()
    }
    
    self.reportTopNavigationView.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide)
      $0.leading.trailing.equalToSuperview()
    }
    
    self.reportView.snp.makeConstraints {
      $0.top.equalTo(self.reportTopNavigationView.snp.bottom)
      $0.trailing.leading.equalToSuperview()
      $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
    }
  }
  
  // MARK: - func
  private func firstSetText() {
    if !storeId.isEmpty {
      self.reportView.reportAddressView.storeNameTextField.text = self.storeInfo.storeNameStr
      self.reportView.reportAddressView.addressTextField.text = self.storeInfo.addressStr
      self.reportView.reportAddressView.detailAddressTextField.text = self.storeInfo.detailAddressStr
      self.reportView.reportDetailDescriptionView.textView.text = self.storeInfo.descriptionStr
      self.reportView.reportDetailDescriptionView.textViewPlaceholderLabel.isHidden = true
    }
  }
  
  // selectedMenu가 카운트 0이 아니면 값이 있으니까 true를 리턴
  private func completeCategoryCheck(_ selectedMenus: [CollectionCount]) -> Bool {
    // isInspection가 true면 dismiss 아니면 모자른 부분 채워야 dismiss
    var isInspection = true
    
    if selectedMenus.count == 0 {
      // 카운트가 0이라면 collection Title을 바꾸라고 Post보냄
      NotificationCenter.default.post(
        name: NSNotification.Name(rawValue: "isCatagoryEmpty"),
        object: nil,
        userInfo: ["isCatagoryEmpty": false]
      )
      isInspection = false
    } else {
      // 카운트가 0이 아니라면 collection Title을 바꾸라고 Post보냄
      NotificationCenter.default.post(
        name: NSNotification.Name(rawValue: "isCatagoryEmpty"),
        object: nil, userInfo: ["isCatagoryEmpty": true]
      )
    }
    
    // 위에 결과로 리턴
    return isInspection
  }
  
  // 테이블뷰에 텍스트필드에 텍스트가 비었는지 확인 후에 true or false 리턴
  private func completeTableViewCheck(_ textContainer: [[TextFieldStorage]]) -> Bool {
    var isInspection = true
    
    for section in 0 ..< textContainer.count {
      for row in 0 ..< textContainer[section].count {
        let cell = self.reportView.selectedMenuTableView.cellForRow(at: IndexPath(row: row, section: section)) as! SelectedMenuTableViewCell
        if textContainer[section][row].firstText == "" {
          DispatchQueue.main.async {
            cell.tasteTextField.layer.borderColor = UIColor.red.cgColor
          }
          isInspection = false
          self.view.layoutIfNeeded()
        } else {
          DispatchQueue.main.async {
            cell.tasteTextField.layer.borderColor = UIColor(
              red: 0.898,
              green: 0.898,
              blue: 0.898,
              alpha: 1
            ).cgColor
          }
          self.view.layoutIfNeeded()
        }
        
        if textContainer[section][row].secondText == "" {
          DispatchQueue.main.async {
            cell.numberAndPriceTextField.layer.borderColor = UIColor.red.cgColor
          }
          isInspection = false
          self.view.layoutIfNeeded()
        } else {
          DispatchQueue.main.async {
            cell.numberAndPriceTextField.layer.borderColor = UIColor(
              red: 0.898,
              green: 0.898,
              blue: 0.898,
              alpha: 1
            ).cgColor
          }
          self.view.layoutIfNeeded()
        }
      }
    }
    
    return isInspection
  }

  
  // MARK: - Action Button
  // 키보드 올라올 때 내려갈 때 위치 잡아주는 곳
  @objc private func keyboardWillShowHide(_ notification: Notification) {
    guard let keyboardValue = notification
            .userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
            as? NSValue else { return }
    
    let keyboardScreenEndFrame = keyboardValue.cgRectValue
    let keyboardViewEndFrame = view.convert(
      keyboardScreenEndFrame,
      from: view.window
    )
    
    if notification.name == UIResponder.keyboardWillHideNotification {
      self.reportView.scrollView.contentInset = .zero
    } else {
      self.reportView.scrollView.contentInset = UIEdgeInsets(
        top: 0,
        left: 0,
        bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom,
        right: 0
      )
    }
//    self.reportView.scrollView.layer.removeAllAnimations()
  }
  
  @objc private func dismissDidTapBtn(_ sender: UIButton) {
    
    self.dismiss(animated: true, completion: nil)
  }
  
  @objc private func kakaoSearchDidTapBtn(_ sender: UIButton) {
    let kakaoVC = ReportSearchViewController()
    
    self.navigationController?.pushViewController(kakaoVC, animated: true)
  }
  
  @objc private func completeDidTapBtn(_ sender: UIButton) {
    print("completedBtn 눌림")
    // ReportAddressView한테 꼭 작성해야 하는 것들이 작성이 됐는지 확인하라고 신호를 보내주는 Post
    // 작성이 됐다면 Post를 보내줌 보내오면 이쪽 함수에서 check변수에 true로 바꿔줌
    NotificationCenter.default.post(
      name: NSNotification.Name("checkInfo"),
      object: nil
    )
    
    // 가장 밑 textView text
    NotificationCenter.default.post(
      name: NSNotification.Name("checkDescription"),
      object: nil
    )
    
    // self.selectedMenu가 카운트가 0이 아니면 true
    // self.selectedMenu가 카운트가 0이라면 title을 변경하라고 Post -> CategoryTitleView
    let isCategory = completeCategoryCheck(self.selectedMenu)

    // 위와 마찬가지로 결과에 따라서 변경됨
    let isMenuText = completeTableViewCheck(self.textfieldStorage)
    
    
    print(self.isPassStore, isCategory, isMenuText)
    if self.isPassStore && isCategory && isMenuText {
      let createdStoreFireStoreService = CreatedStoreFireStoreService()
      let indiVC = IndicatorViewController()
      
      indiVC.modalPresentationStyle = .overFullScreen
      self.present(indiVC, animated: false, completion: nil)
      
      createdStoreFireStoreService.createdStoreFireStoreService(
        selectedMenus: self.selectedMenu,
        textContainer: self.textfieldStorage,
        storeInfo: self.storeInfo,
        storeId: self.storeId
      ) {
        let reportCompleteVC = ReportCompleteViewController()
        
        reportCompleteVC.modalPresentationStyle = .fullScreen
        indiVC.isDismiss = true
        
        self.present(reportCompleteVC, animated: true, completion: {
          // 방금 저장한 정보를 맵에 뿌려주라고 알림을 보냄
          // 수정한 데이터면 storeId도 넘겨 줘서 그 전에 있던 marker를 삭제하고 수정한 marker를 찍어준다
          // 수정한 데이터면 storeId도 넘겨 줘서 getData캐싱한 값도 삭제한다
          NotificationCenter.default.post(
            name: NSNotification.Name("appendMarker"),
            object: nil,
            userInfo: ["storeId": self.storeId]
          )
          
          for i in 0 ..< StoreShared.shared.getStores.count {
            if StoreShared.shared.getStores[i].id == self.storeId {
              StoreShared.shared.getStores.remove(at: i)
              return
            }
          }
        })
      }
      
    }
  }
  
  @objc private func getDescription(_ notification: Notification) {
    guard let textViewText = notification.userInfo?["textViewText"] as? String else {
      return print("getDescription에서 textViewText 받아온 값이 없음 - ReportVC")
    }
    
    self.storeInfo.descriptionStr = textViewText
    print("textView 받아옴", textViewText)
  }
  
  @objc private func passInfoAddress(_ notification: Notification) {
    guard let storeName = notification.userInfo?["storeName"] as? String,
          let addressStr = notification.userInfo?["addressStr"] as? String,
          let detailAddressStr = notification.userInfo?["detailAddressStr"] as? String,
          let latitude = notification.userInfo?["latitude"] as? Double,
          let longitude = notification.userInfo?["longitude"] as? Double else {
      return print("ReportAddressView에서 받아온 값이 없음 - ReportVC")
    }
    // 수정을 누르고 주소변경을 안하면 값이 0으로 들어옴 그래서 수정에서 받아온 값을 넣어준다
    let lat = self.storeInfo.latitude
    let long = self.storeInfo.longitude
    if latitude == 0 && longitude == 0 {
      self.storeInfo = StoreInfo(
        storeNameStr: storeName,
        addressStr: addressStr,
        detailAddressStr: detailAddressStr,
        descriptionStr: "",
        latitude: lat,
        longitude: long
      )
      print("storeInfo 체크 완료")
      self.isPassStore = true
      return
    }
    
    self.storeInfo = StoreInfo(
      storeNameStr: storeName,
      addressStr: addressStr,
      detailAddressStr: detailAddressStr,
      descriptionStr: "",
      latitude: latitude,
      longitude: longitude
    )
    print("storeInfo 체크 완료")
    self.isPassStore = true
  }
  
  deinit {
    print("deinit - ReportVC")
  }
}

// MARK: - UICollectionViewDataSource Extension
extension ReportViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return MenuStrArr.menuStrArr.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: ReportMenuCVCell.identifier,
      for: indexPath
    ) as! ReportMenuCVCell
    
    let isSelected = self.firstCategoryCheck(indexPathItem: indexPath.item)
    
    if isSelected {
      cell.menuConfigure(
        titleImage: UIImage(
          named: "Selected\(MenuImageStrArr.menuImageStrArr[indexPath.item])"
        )!,
        titleStr: MenuStrArr.menuStrArr[indexPath.item]
      )
      cell.isCellSelcted = true
    } else {
      cell.menuConfigure(
        titleImage: UIImage(named: MenuImageStrArr.menuImageStrArr[indexPath.item])!,
        titleStr: MenuStrArr.menuStrArr[indexPath.item]
      )
    }
    
    return cell
  }
  
  // 수정에서 데이터를 받아오면 그거에 맞춰서 셀렉트를 해줘야함
  private func firstCategoryCheck(indexPathItem: Int) -> Bool {
    for i in 0 ..< self.selectedMenu.count {
      if self.selectedMenu[i].sectionCount == indexPathItem {
        
        return true
      }
    }
    
    return false
  }
}

// MARK: - UICollectionViewDelegate Extension
extension ReportViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    self.categorySelected(indexPath)
  }
  
  private func categorySelected(_ indexPath: IndexPath) {
    let cell = self.reportView.categoryCollectionView.cellForItem(at: indexPath) as! ReportMenuCVCell
    let image: UIImage
    
    if cell.isCellSelcted {
      image = UIImage(
        named: MenuImageStrArr.menuImageStrArr[indexPath.item]
      )!

      self.collctionViewUpdate(indexPath: indexPath)
    } else {
      image = UIImage(
        named: "Selected\(MenuImageStrArr.menuImageStrArr[indexPath.item])"
      )!
      // 선택이 되면 몇 번째를 선택했는지 cellCount를 추가해준다
      self.selectedMenu.append(
        CollectionCount(sectionCount: indexPath.item, cellCount: 1)
      )
      // 선택이 되면 텍스트필드 텍스트를 저장할 텍스트스토리지를 추가해준다
      self.textfieldStorage.append([TextFieldStorage(firstText: "", secondText: "")])
      print("collection선택 : ", textfieldStorage)
      self.reportView.selectedMenuTableView.snp.updateConstraints {
        $0.height.equalTo(self.reportView.selectedMenuTableView.contentSize.height + 100)
      }
    }
    cell.didTapUpdateImageView(image)
    
    self.reportView.selectedMenuTableView.reloadData()
    
    self.reportView.scrollView.layoutIfNeeded()
    self.reportView.layoutIfNeeded()
    
    self.view.layoutIfNeeded()
  }
  
  private func collctionViewUpdate(indexPath: IndexPath) {
    for i in 0 ..< self.selectedMenu.count {
      if self.selectedMenu[i].sectionCount == indexPath.item {
        
        self.selectedMenu.remove(at: i)
        self.textfieldStorage.remove(at: i)
        print(textfieldStorage)
        self.reportView.selectedMenuTableView.deleteSections([i], with: .fade)
        
        return
      }
    }
  }
}

// MARK: - UICollectionViewDelegateFlowLayout Extension
extension ReportViewController: UICollectionViewDelegateFlowLayout {
  //지정된 셀의 크기를 반환하는 메서드.
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let contentWidth = collectionView.bounds.width -
      (CollectionLayout.cellSpacing * (CollectionLayout.itemCount - 1)) -
      (CollectionLayout.sectionInset.left + CollectionLayout.sectionInset.right)
    let cellWidth = contentWidth / CollectionLayout.itemCount
    let testSizeLabel = UILabel()
    let height = ("text" as NSString)
      .size(withAttributes: [NSAttributedString.Key.font : testSizeLabel.font as Any]).height
    
    return CGSize(width: cellWidth, height: cellWidth + 4 + height)
  }
  
  //지정된 섹션의 여백을 반환하는 메서드.
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    
    return CollectionLayout.sectionInset
  }
  
  // 첫 줄과 두번 째 줄 사이의 거리
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    
    return CollectionLayout.lineSpacing
  }
  
  // 첫 줄에 셀들의 여백
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    
    return CollectionLayout.cellSpacing
  }
  
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    // 마지막 셀이 로드가 되면 임의 저장한 height를 진짜 자신의 크기를 계산해서 height를 업데이트
    
    if indexPath.item == MenuStrArr.menuStrArr.count - 1 {
      self.reportView.categoryCollectionView.snp.updateConstraints {
        $0.height.equalTo(cell.frame.maxY)
      }
    }
  }
}

extension ReportViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return self.selectedMenu.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.selectedMenu[section].cellCount
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(
      withIdentifier: SelectedMenuTableViewCell.identifier,
      for: indexPath
    ) as! SelectedMenuTableViewCell
    
    cell.indexPath = indexPath
    cell.tasteTextField.delegate = self
    cell.tasteTextField.tag = 0
    cell.tasteTextField.text = self.textfieldStorage[indexPath.section][indexPath.row].firstText
    cell.numberAndPriceTextField.delegate = self
    cell.numberAndPriceTextField.tag = 1
    cell.numberAndPriceTextField.text = self.textfieldStorage[indexPath.section][indexPath.row].secondText
    cell.delegate = self
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let selectedMenuTableHeaderView = SelectedMenuTableHeaderView()
    let selectedMenuStr = MenuImageStrArr.menuImageStrArr[
      self.selectedMenu[section].sectionCount
    ]
    
    let imageStr = "Menu\(selectedMenuStr)"
    let titleStr = MenuStrArr.menuStrArr[self.selectedMenu[section].sectionCount]
    
    if section == 0 {
      selectedMenuTableHeaderView.configuer(imageStr, titleStr, false)
    } else {
      selectedMenuTableHeaderView.configuer(imageStr, titleStr, true)
    }
    
    return selectedMenuTableHeaderView
  }
  
  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    let selectedMenuTableFooterView = SelectedMenuTableFooterView()
    
    selectedMenuTableFooterView.moreBtn.tag = section
    selectedMenuTableFooterView.moreBtn.addTarget(
      self,
      action: #selector(self.moreDidTapBtn),
      for: .touchUpInside
    )
    return selectedMenuTableFooterView
  }
  
  @objc private func moreDidTapBtn(_ sender: UIButton) {
    let selectedSection = sender.tag
    self.selectedMenu[selectedSection].cellCount += 1
    self.textfieldStorage[selectedSection].append(contentsOf: [TextFieldStorage(firstText: "", secondText: "")])
    print(textfieldStorage)
    self.reportView.selectedMenuTableView.reloadData()
    self.reportView.scrollView.layoutIfNeeded()
    self.reportView.layoutSubviews()
    
    self.view.layoutIfNeeded()
  }
}

extension ReportViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
    return UITableView.automaticDimension
  }
}

extension ReportViewController: SelectedMenuTableViewCellDelegate {
  func deleteDelegate(_ indexPath: IndexPath) {
    let section = indexPath.section
    let row = indexPath.row
    
    self.selectedMenu[section].cellCount -= 1

    if self.selectedMenu[section].cellCount == 0 {
      let collectionSection = IndexPath(
        item: self.selectedMenu[section].sectionCount,
        section: 0
      )
      
      self.selectedMenu.remove(at: section)
      self.textfieldStorage.remove(at: section)
      
      self.collectionDeSelected(indexPath: collectionSection)
      
      self.reportView.selectedMenuTableView.deleteSections(
        [indexPath.section],
        with: .fade
      )
    } else {
      self.reportView.selectedMenuTableView.deleteRows(
        at: [indexPath],
        with: .middle
      )
      self.textfieldStorage[section].remove(at: row)
      print(self.textfieldStorage)
    }
    
    self.reportView.selectedMenuTableView.reloadData()
    self.reportView.scrollView.layoutIfNeeded()
    self.view.layoutIfNeeded()
  }
  
  private func collectionDeSelected(indexPath: IndexPath) {
    let cell = self.reportView.categoryCollectionView.cellForItem(
      at: indexPath
    ) as! ReportMenuCVCell
    let image = UIImage(
      named: MenuImageStrArr.menuImageStrArr[indexPath.item]
    )!
    
    cell.didTapUpdateImageView(image)
  }
}

extension ReportViewController: UITextFieldDelegate {
  func textFieldDidChangeSelection(_ textField: UITextField) {
    guard let cell = textField.superview?.superview as? SelectedMenuTableViewCell,
          let indexPath = cell.indexPath,
          let text = textField.text else {
      return print("textField Cell이 없음")
    }
    
    switch textField.tag {
    case 0:
      cell.tasteTextField.layer.borderColor = UIColor(
        red: 0.898,
        green: 0.898,
        blue: 0.898,
        alpha: 1
      ).cgColor
      self.textfieldStorage[indexPath.section][indexPath.row].firstText = text
      print(self.textfieldStorage, indexPath, "첫번째")
    case 1:
      cell.numberAndPriceTextField.layer.borderColor = UIColor(
        red: 0.898,
        green: 0.898,
        blue: 0.898,
        alpha: 1
      ).cgColor
      self.textfieldStorage[indexPath.section][indexPath.row].secondText = text
      print(self.textfieldStorage, indexPath, "두번째")
    default:
      break
    }
    
  }
}
