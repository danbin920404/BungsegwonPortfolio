//
//  MainReportViewController.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/22.
//

import UIKit

class MainReportViewController: UIViewController {
  // MARK: - Properties
  private let mainReportView = MainReportView()
  
  // MARK: - View LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.setUI()
    self.setLayout()
  }
  
  // MARK: - SetUI
  private func setUI() {
    self.view.addSubview(self.mainReportView)
    
    self.navigationController?.isNavigationBarHidden = true
    self.tabBarController?.tabBar.tintColor = .white
    self.tabBarController?.tabBar.isTranslucent = false
    
    self.view.backgroundColor = .white
    
    self.mainReportView.reportBtn.addTarget(
      self,
      action: #selector(self.reportDidTapBtn),
      for: .touchUpInside
    )
  }
  
  // MARK: - SetLayout
  private func setLayout() {
    self.mainReportView.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
    }
  }
  
  // MARK: - Action Button
  @objc private func reportDidTapBtn(_ sender: UIButton) {
    
    
    guard let islogin = UserDefaults.standard.value(forKey: "isLogin") as? Bool else {
      return print("유저디폴트에 isLogin값이 없음 - MyPageViewController")
    }
    
    if islogin {
      let reportVC = ReportViewController()
      let naviC = UINavigationController(rootViewController: reportVC)
      
      naviC.modalPresentationStyle = .overFullScreen
      self.present(naviC, animated: true, completion: nil)
    } else {
      let mainSingUpVC = MainSingUpViewController()
      
      mainSingUpVC.modalPresentationStyle = .overFullScreen
      mainSingUpVC.delegate = self
      self.present(mainSingUpVC, animated: true, completion: nil)
    }
  }
}

// MARK: - Extension
extension MainReportViewController: MainSingUpViewControllerDelegate {
  func titleImageViewIsHidden() -> Bool {
    return true
  }
  
  
}
