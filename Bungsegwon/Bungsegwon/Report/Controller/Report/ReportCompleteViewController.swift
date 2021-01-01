//
//  ReportCompleteViewController.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/22.
//

import UIKit

class ReportCompleteViewController: UIViewController {
  // MARK: - Properties
  private let reportCompleteNextView = ReportCompleteNextView()
  
  // MARK: - View LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.setUI()
    self.setLayout()
  }
  // MARK: - SetUI
  private func setUI() {
    self.view.addSubview(self.reportCompleteNextView)
    
    self.view.backgroundColor = .white
    
    self.reportCompleteNextView.dismissBtn.addTarget(
      self,
      action: #selector(self.dismissDidTapBtn),
      for: .touchUpInside
    )
  }
  
  // MARK: - SetLayout
  private func setLayout() {
    self.reportCompleteNextView.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide)
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
    }
  }
  
  // MARK: - Action Button
  @objc private func dismissDidTapBtn(_ sender: UIButton) {
    guard let window = self.view.window,
          let rootView = window.rootViewController else { return }
    
    if let tabBar = rootView as? UITabBarController {
      if let navi = tabBar.selectedViewController as? UINavigationController {
        for vc in navi.viewControllers {
          if let a = vc as? MyPageDetailViewController {
            navi.popToViewController(a, animated: false)
          }
        }
        tabBar.dismiss(animated: false) {
          navi.popViewController(animated: false)
        }
        
      }
    }
  }
  
}

// MARK: - Extension

