// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

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
