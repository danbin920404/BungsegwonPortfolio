//
//  MainTabBarController.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/22.
//

import UIKit

class MainTabBarController: UITabBarController {
  // MARK: - Properties
  
  // MARK: - View LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.setUI()
    self.setLayout()
  }
  
  // MARK: - SetUI
  private func setUI() {
    
    let mainVC = UINavigationController(rootViewController: MainMapViewController())
    mainVC.tabBarItem = UITabBarItem(
      title: nil,
      image: UIImage(named: "MapTabBarImage"),
      selectedImage: UIImage(named: "MapTabBarSeletedImage")!.withRenderingMode(
        UIImage.RenderingMode.alwaysOriginal
      )
    )
    
    let reportVC = UINavigationController(rootViewController: MainReportViewController())
    reportVC.tabBarItem = UITabBarItem(
      title: nil,
      image: UIImage(named: "ReportTabBarImage"),
      selectedImage: UIImage(named: "ReportTabBarSeletedImage")!.withRenderingMode(
        UIImage.RenderingMode.alwaysOriginal
      )
    )
    
    let myPageVC = UINavigationController(rootViewController: MyPageViewController())
    myPageVC.tabBarItem = UITabBarItem(
      title: nil,
      image: UIImage(named: "MyPageTabBarImage"),
      selectedImage: UIImage(named: "MyPageTabBarSeletedImage")!.withRenderingMode(
        UIImage.RenderingMode.alwaysOriginal
      )
    )
    
    viewControllers = [
      mainVC,
      reportVC,
      myPageVC
    ]
  }
  
  // MARK: - SetLayout
  private func setLayout() {
    
  }
  
  // MARK: - Action Button
}

// MARK: - Extension

