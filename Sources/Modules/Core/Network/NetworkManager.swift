//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireNetworkActivityIndicator
import RxSwift
import RxAlamofire

class NetworkManager: NetworkManagerType {

  // MARK: - Init

  init() {
    NetworkActivityIndicatorManager.shared.isEnabled = true
    self.reachability?.startListening()
  }

  // MARK: - Reachability

  private lazy var reachability = NetworkReachabilityManager(host: "www.google.com")

  var reachabilityStatus: ReachabilityStatus {
    let status = self.reachability?.networkReachabilityStatus ?? .unknown
    switch status {
    case .reachable:    return .reachable
    case .notReachable: return .notReachable
    case .unknown:      return .unknown
    }
  }

  // MARK: - Requests

  private lazy var session = SessionManager()

  func request(_ url:      URLConvertible,
               method:     HTTPMethod,
               parameters: Parameters?,
               encoding:   ParameterEncoding,
               headers:    HTTPHeaders?) -> Observable<Data> {
    return self.session.rx.request(method, url, parameters: parameters, encoding: encoding, headers: headers)
      .flatMap { $0.validate().rx.data() }
  }
}
