//
//  NetworkMonitor.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/22.
//

import Foundation
import Network

final class NetworkMonitor {
  static let shared = NetworkMonitor()
  
  private let queue = DispatchQueue.global()
  private let monitor: NWPathMonitor
  
  public private(set) var isConneted: Bool = false
  
  public private(set) var connectionType: ConnectionType = .unknown
  
  enum ConnectionType {
    case wifi
    case cellular
    case ethernet
    case unknown
  }
  
  private init() {
    self.monitor = NWPathMonitor()
  }
  
  public func startMonitoring() {
    self.monitor.start(queue: self.queue)
    self.monitor.pathUpdateHandler = { [weak self] path in
      self?.isConneted = path.status == .satisfied
      
      self?.getConnectionType(path)
    }
  }
  
  public func stopMonitoring() {
    self.monitor.cancel()
  }
  
  public func getConnectionType(_ path: NWPath) {
    if path.usesInterfaceType(.wifi) {
      
      self.connectionType = .wifi
    } else if path.usesInterfaceType(.cellular) {
      
      self.connectionType = .cellular
    } else if path.usesInterfaceType(.wiredEthernet) {
      
      self.connectionType = .ethernet
    } else {
      
      self.connectionType = .unknown
    }
  }
}

