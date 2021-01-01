//
//  AppDelegate.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/22.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import GoogleSignIn
import NMapsMap

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    
    // 네트워크가 연결되어 있는지 모니터링 시작
    NetworkMonitor.shared.startMonitoring()
    
    // 네이버맵 클라이언트 아이디
    NMFAuthManager.shared().clientId = ""
    
    // 파이어베이스 초기화
    FirebaseApp.configure()
    
    // 페이스북 로그인
    ApplicationDelegate.shared.application(
      application,
      didFinishLaunchingWithOptions: launchOptions
    )
    
    // 구글 로그인
    GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
    
    return true
  }
  
  func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    guard let scheme = url.scheme else { return true  }
//    if scheme.contains("fb") {
//      ApplicationDelegate.shared.application(
//        app,
//        open: url,
//        sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication]
//          as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation]
//      )
//    } else
  if scheme.contains("com.googleusercontent.apps") {
      return GIDSignIn.sharedInstance().handle(url)
    }

    return true
  }
  
  func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
      return GIDSignIn.sharedInstance().handle(url)
  }

  // MARK: UISceneSession Lifecycle

  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
  }

  // 가로 모드를 허용할 것인지 결정
  func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
    // 세로 모드
    return UIInterfaceOrientationMask.portrait
  }
}

