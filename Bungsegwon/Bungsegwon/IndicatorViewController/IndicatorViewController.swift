//
//  IndicatorViewController.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/22.
//

import UIKit

class IndicatorViewController: UIViewController {
  // MARK: - Properties
  private let indicator = UIActivityIndicatorView()
  var isDismiss = false {
    didSet {
      print(self.isDismiss)
      self.indicator.stopAnimating()
      self.dismiss(animated: false, completion: nil)
    }
  }
  
  // MARK: - View LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.setUI()
    self.setLayout()
  }
  // MARK: - SetUI
  private func setUI() {
    self.view.addSubview(self.indicator)
    
    self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
    
    self.indicator.startAnimating()
  }
  
  // MARK: - SetLayout
  private func setLayout() {
    self.indicator.snp.makeConstraints {
      $0.centerY.centerX.equalToSuperview()
    }
  }
  
  // MARK: - Action Button
  
  deinit {
    print("deinit - IndicatorViewController")
  }
}

// MARK: - Extension

