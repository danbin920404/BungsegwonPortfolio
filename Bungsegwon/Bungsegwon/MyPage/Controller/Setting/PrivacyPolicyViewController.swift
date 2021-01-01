//
//  PrivacyPolicyViewController.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/22.
//

import UIKit
import WebKit

class PrivacyPolicyViewController: UIViewController {
  // MARK: - Properties
  var titleStr = ""
  lazy var topNavigationView = TopNavigationView(frame: .zero, isLeftAndRightBtn: true, titleStr: self.titleStr)
  private let webView = WKWebView()
  
  
  // MARK: - View LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.setUI()
    self.setLayout()
  }
  // MARK: - SetUI
  private func setUI() {
    [
      self.webView,
      self.topNavigationView
    ].forEach {
      self.view.addSubview($0)
    }
    
    self.view.backgroundColor = .white
    
    let sURL = "https://danbin920404.github.io/FrenchVocaPrivacyPolicy/"
    let uURL = URL(string: sURL)
    let request = URLRequest(url: uURL!)
    self.webView.load(request)
    
    self.topNavigationView.leftDismissBtn.addTarget(
      self,
      action: #selector(self.dismissDidTapBtn),
      for: .touchUpInside
    )
  }
  
  // MARK: - SetLayout
  private func setLayout() {
    self.topNavigationView.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
      $0.leading.trailing.equalToSuperview()
    }
    
    self.webView.snp.makeConstraints {
      $0.top.equalTo(self.topNavigationView.snp.bottom)
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
    }
  }
  
  // MARK: - Action Button
  @objc private func dismissDidTapBtn(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
}

// MARK: - Extension

