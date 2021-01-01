//
//  SettingsViewController.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/22.
//

import UIKit

import UIKit
import MessageUI

class SettingsViewController: UIViewController {
  // MARK: - Properties
  private let topNavigationView = TopNavigationView(
    frame: .zero,
    isLeftAndRightBtn: true,
    titleStr: "설정"
  )
  private let settingView = SettingsView()
  private let settingTitles = [
    "개인정보처리방침",
    "이메일 문의하기",
    "Open Source Licenses",
    "현재 버전"
  ]
  private let cellBottomMargins: [CGFloat] = [1, 16, 16, 0]
  
  // MARK: - View LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.setUI()
    self.setLayout()
  }
  
  // MARK: - SetUI
  private func setUI() {
    [
      self.settingView,
      self.topNavigationView
    ].forEach {
      self.view.addSubview($0)
    }
    
    self.view.backgroundColor = .white
    
    self.topNavigationView.leftDismissBtn.addTarget(
      self,
      action: #selector(self.leftDismissDidTapBtn),
      for: .touchUpInside
    )
    
    self.settingView.contentsTableView.dataSource = self
    self.settingView.contentsTableView.delegate = self
    self.settingView.contentsTableView.register(
      SettingsTableViewCell.self,
      forCellReuseIdentifier: SettingsTableViewCell.identifier
    )
  }
  
  // MARK: - SetLayout
  private func setLayout() {
    self.topNavigationView.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
      $0.leading.trailing.equalToSuperview()
    }
    
    self.settingView.snp.makeConstraints {
      $0.top.equalTo(self.topNavigationView.snp.bottom)
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
    }
  }
  
  // MARK: - Action Button
  @objc private func leftDismissDidTapBtn(_ sender: UIButton) {
    
    self.navigationController?.popViewController(animated: true)
  }
  
  deinit {
    print("deinit SettingsViewController")
  }
}

// MARK: - UITableViewDataSource Extension
extension SettingsViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.settingTitles.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(
      withIdentifier: SettingsTableViewCell.identifier,
      for: indexPath
    ) as! SettingsTableViewCell
    
    cell.selectionStyle = .none
    
    cell.configureTitleText(
      self.settingTitles[indexPath.row],
      bottomMargin: self.cellBottomMargins[indexPath.row]
    )
    
    return cell
  }
}

// MARK: - UITableViewDelegate Extension
extension SettingsViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch indexPath.row {
    case 0:
      let licenseVC = PrivacyPolicyViewController()
      
      licenseVC.titleStr = self.settingTitles[indexPath.row]
      licenseVC.hidesBottomBarWhenPushed = true
      self.navigationController?.pushViewController(licenseVC, animated: true)
    case 1:
      if MFMailComposeViewController.canSendMail() {
              let mail = MFMailComposeViewController()
              mail.mailComposeDelegate = self
              mail.setToRecipients(["seongdanbin@gmail.com"])
              mail.setMessageBody("<p>붕세권에게 말씀해주세요.</p>", isHTML: true)

              present(mail, animated: true)
          } else {
              // show failure alert
          }
      print("이메일 보내기")
    case 2:
      let licenseVC = LicenseViewController()
      let naviC = UINavigationController(rootViewController: licenseVC)
      licenseVC.titleStr = self.settingTitles[indexPath.row]
      
      naviC.modalPresentationStyle = .fullScreen
      self.present(naviC, animated: true, completion: nil)
    case 3:
      print("현재 버전")
    default:
      break
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
}

extension SettingsViewController: MFMailComposeViewControllerDelegate {
  func mailComposeController(
    _ controller: MFMailComposeViewController,
    didFinishWith result: MFMailComposeResult,
    error: Error?) {
    
    if error != nil {
      print("email error", error!.localizedDescription)
    }
    
    switch result {
    case .saved:
      print("email 저장")
    case .failed:
      print("email 실패")
    case .cancelled:
      print("email 보내기 취소함")
    case .sent:
      print("email 보냄")
    default:
      break
    }
    
      controller.dismiss(animated: true)
  }
}
