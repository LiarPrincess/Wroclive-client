// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import Alamofire
import RxSwift
import RxAlamofire

protocol NetworkManagerType {

  /// Get data from the network
  func request(url: URLConvertible,
               method: HTTPMethod,
               parameters: Parameters?,
               encoding: ParameterEncoding,
               headers: HTTPHeaders?) -> Observable<DataRequest>

  /// Show/hide network activity indicator (little circle in the upper left corner)
  func setNetworkActivityIndicatorVisibility(_ isVisible: Bool)
}

// sourcery: manager
class NetworkManager: NetworkManagerType {

  func request(url: URLConvertible,
               method: HTTPMethod,
               parameters: Parameters?,
               encoding: ParameterEncoding,
               headers: HTTPHeaders?) -> Observable<DataRequest> {
    return SessionManager.default.rx.request(method, url, parameters: parameters, encoding: encoding, headers: headers)
  }

  func setNetworkActivityIndicatorVisibility(_ isVisible: Bool) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = isVisible
  }
}
