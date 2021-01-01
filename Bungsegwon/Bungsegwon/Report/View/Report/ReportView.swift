//
//  ReportView.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/22.
//

import UIKit

class ReportView: UIView {
  // MARK: - Properties
  let scrollView = UIScrollView()
  let reportAddressView = ReportAddressView()
  private let categoryTitleView = CategoryTitleView()
  private let collectionViewLayout = UICollectionViewFlowLayout()
  lazy var categoryCollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: self.collectionViewLayout
  )
  let selectedMenuTitleView = SelectedMenuTitleView()
  let selectedMenuTableView = UITableView()
  let reportDetailDescriptionView = ReportDetailDescriptionView()
  let reportCompleteView = ReportCompleteView()
  
  // MARK: - View LifeCycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.setUI()
    self.setLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    self
      .scrollView
      .contentSize
      .height = self
      .reportCompleteView
      .frame.maxY
  }
  
  // MARK: - SetUI
  private func setUI() {
    self.backgroundColor = UIColor(
      red: 0.957,
      green: 0.957,
      blue: 0.957,
      alpha: 1
    )
    
    [
      self.scrollView,
    ].forEach {
      self.addSubview($0)
    }
    
    [
      self.reportAddressView,
      self.categoryTitleView,
      self.categoryCollectionView,
      self.selectedMenuTitleView,
      self.selectedMenuTableView,
      self.reportDetailDescriptionView,
      self.reportCompleteView
    ].forEach {
      self.scrollView.addSubview($0)
    }
    
    self.scrollView.backgroundColor = UIColor(
      red: 0.957,
      green: 0.957,
      blue: 0.957,
      alpha: 1
    )
    
    self.categoryCollectionView.isScrollEnabled = false
    self.categoryCollectionView.backgroundColor = UIColor(
      red: 0.957,
      green: 0.957,
      blue: 0.957,
      alpha: 1
    )
    
    self.selectedMenuTableView.isScrollEnabled = false
    self.selectedMenuTableView.separatorStyle = .none
    self.selectedMenuTableView.backgroundColor = UIColor(
      red: 0.957,
      green: 0.957,
      blue: 0.957,
      alpha: 1
    )
    
    // 화면을 터치하면 키보드를 내리는 제스쳐
    let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.keyboardWillShowHide))
    singleTapGestureRecognizer.numberOfTapsRequired = 1
    singleTapGestureRecognizer.isEnabled = true
    singleTapGestureRecognizer.cancelsTouchesInView = false
    self.scrollView.addGestureRecognizer(singleTapGestureRecognizer)
  }
  
  // MARK: - SetLayout
  private func setLayout() {
    self.scrollView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalToSuperview().offset(0)
    }
    
    self.reportAddressView.snp.makeConstraints {
      $0.top.leading.trailing.equalTo(self.scrollView.contentLayoutGuide)
      $0.width.equalToSuperview()
    }
    
    self.categoryTitleView.snp.makeConstraints {
      $0.top.equalTo(self.reportAddressView.snp.bottom)
      $0.leading.trailing.width.equalTo(self.scrollView.contentLayoutGuide)
    }
    
    self.categoryCollectionView.snp.makeConstraints {
      $0.top.equalTo(self.categoryTitleView.snp.bottom)
      $0.leading.trailing.equalTo(self.scrollView.contentLayoutGuide)
      // 임의에 값을 설정하고 collectionView
      // willDisplay에서 마지막의 셀의 maxY 값으로 정확하기 다시 업데이트
      $0.height.equalTo(400)
    }
    
    self.selectedMenuTitleView.snp.makeConstraints {
      $0.top.equalTo(self.categoryCollectionView.snp.bottom)
      $0.leading.trailing.equalTo(self.scrollView.contentLayoutGuide)
    }
    
    self.selectedMenuTableView.snp.makeConstraints {
      $0.top.equalTo(self.selectedMenuTitleView.snp.bottom)
      $0.leading.trailing.equalTo(self.scrollView.contentLayoutGuide)
      $0.height.equalTo(0)
    }
    
    self.reportDetailDescriptionView.snp.makeConstraints {
      $0.top.equalTo(self.selectedMenuTableView.snp.bottom)
      $0.leading.trailing.equalTo(self.scrollView.contentLayoutGuide)
    }
    
    self.reportCompleteView.snp.makeConstraints {
      $0.top.equalTo(self.reportDetailDescriptionView.snp.bottom)
      $0.leading.trailing.bottom.equalTo(self.scrollView.contentLayoutGuide)
    }
  }
  
  // MARK: - Action Button
  @objc private func keyboardWillShowHide(sender: UITapGestureRecognizer) {
    
    self.endEditing(true)
  }
  
  deinit {
    print("deinit - ReportView")
  }
}

// MARK: - Extension
