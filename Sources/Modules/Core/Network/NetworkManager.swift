//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit

protocol NetworkManager {

  var reachabilityStatus: ReachabilityStatus { get }

  /// Send request
  func request(_ url:      URLConvertible,
               method:     HTTPMethod,
               parameters: Parameters?,
               encoding:   ParameterEncoding,
               headers:    HTTPHeaders?) -> DataRequest
}
