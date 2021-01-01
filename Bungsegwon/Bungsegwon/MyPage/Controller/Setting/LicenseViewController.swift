//
//  LicenseViewController.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/22.
//

import UIKit

class LicenseViewController: UIViewController {
  // MARK: - Properties
  var titleStr = ""
  lazy var topNavigationView = TopNavigationView(frame: .zero, isLeftAndRightBtn: false, titleStr: self.titleStr)
  private let tableView = UITableView()
  
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
      self.tableView,
      self.topNavigationView
    ].forEach {
      self.view.addSubview($0)
    }
    
    self.view.backgroundColor = .white
    
    self.topNavigationView.rightDismissBtn.addTarget(
      self,
      action: #selector(self.dismissDidTapBtn),
      for: .touchUpInside
    )
    
    self.tableView.separatorStyle = .none
    self.tableView.dataSource = self
    self.tableView.delegate = self
    self.tableView.register(
      LicenseTableViewCell.self,
      forCellReuseIdentifier: LicenseTableViewCell.identifier
    )
    self.tableView.backgroundColor = UIColor(
      red: 0.957,
      green: 0.957,
      blue: 0.957,
      alpha: 1
    )
  }
  
  // MARK: - SetLayout
  private func setLayout() {
    self.topNavigationView.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
      $0.leading.trailing.equalToSuperview()
    }
    
    self.tableView.snp.makeConstraints {
      $0.top.equalTo(self.topNavigationView.snp.bottom)
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
    }
  }
  
  // MARK: - Action Button
  @objc private func dismissDidTapBtn(_ sender: UIButton) {
    self.dismiss(animated: true, completion: nil)
  }
}

// MARK: - UITableViewDataSource Extension
extension LicenseViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return LicenseTitle.licenseTitle.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(
      withIdentifier: LicenseTableViewCell.identifier,
      for: indexPath
    ) as! LicenseTableViewCell
    
    cell.configuer(title: LicenseTitle.licenseTitle[indexPath.row])
    
    return cell
  }
}

// MARK: - UITableViewDelegate Extension
extension LicenseViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let licenseDetailVC = LicenseDetailViewController()
    
    licenseDetailVC.titleStr = LicenseTitle.licenseTitle[indexPath.row]
    licenseDetailVC.textView.text = licenseText(indexPath: indexPath)
    self.navigationController?.pushViewController(licenseDetailVC, animated: true)
  }
  private func licenseText(indexPath: IndexPath) -> String {
    let row =  indexPath.row
    
    if row == 0 {
      return LicenseText.licenseText[row]
    } else if row <= 2 {
      return LicenseText.licenseText[1]
    } else if row <= 17 {
      return LicenseText.licenseText[2]
    } else if row == 18 {
      return LicenseText.licenseText[3]
    } else if row == 19 {
      return LicenseText.licenseText[4]
    } else if row == 20 {
      return LicenseText.licenseText[5]
    } else {
      return LicenseText.licenseText[6]
    }
  }
}

