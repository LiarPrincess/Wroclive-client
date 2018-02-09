//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireNetworkActivityIndicator
import Reachability
import RxSwift
import RxAlamofire
import RxReachability

class NetworkManager: NetworkManagerType {

  // MARK: - Init

  init() {
    NetworkActivityIndicatorManager.shared.isEnabled = true
    try? self._reachability?.startNotifier()
  }

  deinit {
    self._reachability?.stopNotifier()
  }

  // MARK: - Reachability

  private lazy var _reachability = Reachability()

  var reachability: Observable<Reachability.Connection> {
    if let reachability = self._reachability {
      return reachability.rx.status.startWith(reachability.connection)
    }
    // If reachability failed then assume that cellular connection is available
    return Observable.just(Reachability.Connection.cellular)
  }

  // MARK: - Requests

  private lazy var _session = SessionManager()

  func request(_ url:      URLConvertible,
               method:     HTTPMethod,
               parameters: Parameters?,
               encoding:   ParameterEncoding,
               headers:    HTTPHeaders?) -> Observable<Data> {
    return self._session.rx.request(method, url, parameters: parameters, encoding: encoding, headers: headers)
      .flatMap { $0.validate().rx.data() }
  }
}
