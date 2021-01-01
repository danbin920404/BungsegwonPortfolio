//
//  LicenseDetailViewController.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/29.
//

import UIKit

class LicenseDetailViewController: UIViewController {
  // MARK: - Properties
  var titleStr = ""
  lazy var topNavigationView = TopNavigationView(frame: .zero, isLeftAndRightBtn: true, titleStr: self.titleStr)
  let textView = UITextView()
  
  // MARK: - View LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.setUI()
    self.setLayout()
  }
  // MARK: - SetUI
  private func setUI() {
    self.navigationController?.isNavigationBarHidden = true
    
    [
      self.textView,
      self.topNavigationView
    ].forEach {
      self.view.addSubview($0)
    }
    
    self.view.backgroundColor = .white
    
    self.topNavigationView.leftDismissBtn.addTarget(
      self,
      action: #selector(self.dismissDidTapBtn),
      for: .touchUpInside
    )
    
    self.textView.delegate = self
  }
  
  // MARK: - SetLayout
  private func setLayout() {
    self.topNavigationView.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
      $0.leading.trailing.equalToSuperview()
    }
    
    self.textView.snp.makeConstraints {
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
extension LicenseDetailViewController: UITextViewDelegate {
  func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
    return false
  }
}

