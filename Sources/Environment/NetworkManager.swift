// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import Alamofire
import RxSwift
import RxAlamofire

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
