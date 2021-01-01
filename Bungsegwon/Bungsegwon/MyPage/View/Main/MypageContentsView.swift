//
//  MypageContentsView.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/22.
//

import UIKit

class MypageContentsView: UIView {
  // MARK: - Properties
  private let favoriteCVLayout = UICollectionViewFlowLayout()
  lazy var favoriteCollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: self.favoriteCVLayout
  )
  private let registerCVLayout = UICollectionViewFlowLayout()
  lazy var registerCollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: self.registerCVLayout
  )
  
  let favoriteCVTitleView = CategoryTitleUIView(titleStr: "내가 찜한 가게")
  let registerCVTilteView = CategoryTitleUIView(titleStr: "내가 등록한 가게")
  let commentTilteView = CategoryTitleUIView(titleStr: "내가 쓴 댓글")
  let commentTableView = UITableView()
  
  // MARK: - View LifeCycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.setUI()
    self.setLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
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
      self.favoriteCVTitleView,
      self.favoriteCollectionView,
      self.registerCVTilteView,
      self.registerCollectionView,
      self.commentTilteView,
      self.commentTableView
    ].forEach {
      self.addSubview($0)
    }
    
    self.favoriteCVLayout.scrollDirection = .horizontal
    
    
    self.favoriteCollectionView.showsHorizontalScrollIndicator = false
    self.favoriteCollectionView.backgroundColor = UIColor(
      red: 0.957,
      green: 0.957,
      blue: 0.957,
      alpha: 1
    )
    
    self.registerCVLayout.scrollDirection = .horizontal
    
    self.registerCollectionView.showsHorizontalScrollIndicator = false
    self.registerCollectionView.backgroundColor = UIColor(
      red: 0.957,
      green: 0.957,
      blue: 0.957,
      alpha: 1
    )
    
    self.commentTableView.isScrollEnabled = false
    self.commentTableView.separatorStyle = .none
    self.commentTableView.backgroundColor = UIColor(
      red: 0.957,
      green: 0.957,
      blue: 0.957,
      alpha: 1
    )
  }
  
  // MARK: - SetLayout
  private func setLayout() {
    self.favoriteCVTitleView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(28)
      $0.leading.trailing.equalToSuperview()
    }
    
    self.favoriteCollectionView.snp.makeConstraints {
      $0.top.equalTo(self.favoriteCVTitleView.snp.bottom)
      $0.leading.trailing.equalToSuperview()
      // 컨텐츠의 원래의 크기 보다는 크게 설정하고 정확한 크기는 컨트롤러에서 지정
      $0.height.equalTo(150)
    }
    
    self.registerCVTilteView.snp.makeConstraints {
      $0.top.equalTo(self.favoriteCollectionView.snp.bottom)
      $0.leading.trailing.equalToSuperview()
    }
    
    self.registerCollectionView.snp.makeConstraints {
      $0.top.equalTo(self.registerCVTilteView.snp.bottom)
      $0.leading.trailing.equalToSuperview()
      // 컨텐츠의 원래의 크기 보다는 크게 설정하고 정확한 크기는 컨트롤러에서 지정
      $0.height.equalTo(150)
    }
    
    self.commentTilteView.snp.makeConstraints {
      $0.top.equalTo(self.registerCollectionView.snp.bottom)
      $0.leading.trailing.equalToSuperview()
    }
    
    self.commentTableView.snp.makeConstraints {
      $0.top.equalTo(self.commentTilteView.snp.bottom).offset(8)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  // MARK: - Action Button
}

// MARK: - Extension
