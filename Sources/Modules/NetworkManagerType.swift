// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import Reachability
import Alamofire
import RxSwift

protocol NetworkManagerType {

  /// Current network status
  var reachability: Observable<Reachability.Connection> { get }

  /// Send request expecting single data or error
  func request(_ url:      URLConvertible,
               method:     HTTPMethod,
               parameters: Parameters?,
               encoding:   ParameterEncoding,
               headers:    HTTPHeaders?) -> Observable<Data>
}
