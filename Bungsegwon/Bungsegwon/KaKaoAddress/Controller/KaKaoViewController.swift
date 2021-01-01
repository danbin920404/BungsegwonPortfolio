//
//  KaKaoViewController.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/22.
//

import UIKit
import WebKit

class KakaoAddressViewController: UIViewController {
  // MARK: - Properties
  private var webView: WKWebView?
  private let indicator = UIActivityIndicatorView(style: .medium)
  private var address = ""
  
  //  MARK: - View LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.setUI()
  }
  
  // MARK: - SetUI
  private func setUI() {
    self.setAttributes()
    self.setLayout()
  }
  
  private func setAttributes() {
    let contentController = WKUserContentController()
    contentController.add(self, name: "callBackHandler")
    
    let configuration = WKWebViewConfiguration()
    configuration.userContentController = contentController
    
    self.webView = WKWebView(frame: .zero, configuration: configuration)
    self.webView?.navigationDelegate = self
    
    view.addSubview(self.webView!)
    
    self.webView?.addSubview(self.indicator)
    
    guard let url = URL(string: "https://danbin920404.github.io/Kakao-PostalCodeService/"),
          let webView = self.webView
    else { return }
    let request = URLRequest(url: url)
    webView.load(request)
    
    self.indicator.startAnimating()
    
  }
  
  // MARK: - SetLayout
  private func setLayout() {
    guard let webView = self.webView else { return }
    
    webView.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide)
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
    }
    
    self.indicator.snp.makeConstraints {
      $0.centerX.equalTo(webView.snp.centerX)
      $0.centerY.equalTo(webView.snp.centerY)
    }
  }
}

// MARK: - WKScriptMessageHandler Extension
extension KakaoAddressViewController: WKScriptMessageHandler {
  func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    guard let data = message.body as? [String: Any],
          let addressStr = data["roadAddress"] as? String else {
      return
    }
  
    if let naviC = self.presentingViewController as? UINavigationController {
      for vc in naviC.viewControllers {
        if ((vc as? ReportSearchViewController) != nil) {
          NotificationCenter.default.post(
            name: NSNotification.Name("SearchVC"),
            object: nil,
            userInfo: ["addressStr": addressStr]
          )
        }
      }
    }
  
    if let tabBarC = self.presentingViewController as? MainTabBarController {
      if let nvc = tabBarC.selectedViewController as? UINavigationController {
        if let _ = nvc.topViewController as? MainMapViewController {
          NotificationCenter.default.post(
            name: NSNotification.Name("kakaoSearchResult"),
            object: nil,
            userInfo: ["addressStr": addressStr]
          )
        }
      }
    }
    
    self.dismiss(animated: true) {
      self.webView = nil
    }
  }
  
  
}

// MARK: - WKNavigationDelegate Extension
extension KakaoAddressViewController: WKNavigationDelegate {
  func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    indicator.startAnimating()
  }
  
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    indicator.stopAnimating()
  }
}
