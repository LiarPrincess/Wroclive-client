// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import Alamofire
import RxSwift
@testable import WrocliveFramework

class NetworkManagerMock: NetworkManagerType {

  func request(url: URLConvertible,
               method: HTTPMethod,
               parameters: Parameters?,
               encoding: ParameterEncoding,
               headers: HTTPHeaders?) -> Observable<DataRequest> {
    fatalError("NetworkManagerMock.request is not implmented")
  }

  private(set) var isNetworkActivityIndicatorVisible = false

  func setNetworkActivityIndicatorVisibility(_ isVisible: Bool) {
    self.isNetworkActivityIndicatorVisible = isVisible
  }
}
