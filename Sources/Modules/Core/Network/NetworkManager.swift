//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireNetworkActivityIndicator

class NetworkManager: NetworkManagerType {

  // MARK: - Properties

  private lazy var session      = SessionManager()
  private lazy var reachability = NetworkReachabilityManager(host: "www.google.com")

  // MARK: - Init

  init() {
    NetworkActivityIndicatorManager.shared.isEnabled = true
    self.reachability?.startListening()
  }

  // MARK: - NetworkManager

  var reachabilityStatus: ReachabilityStatus {
    let status = self.reachability?.networkReachabilityStatus ?? .unknown
    switch status {
    case .reachable:    return .reachable
    case .notReachable: return .notReachable
    case .unknown:      return .unknown
    }
  }

  func request(_ url:      URLConvertible,
               method:     HTTPMethod,
               parameters: Parameters?,
               encoding:   ParameterEncoding,
               headers:    HTTPHeaders?) -> DataRequest {
    return self.session.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
  }
}
