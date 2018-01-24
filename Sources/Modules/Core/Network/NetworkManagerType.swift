//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

protocol NetworkManagerType {

  // MARK: - Reachability

  /// Current network status
  var reachabilityStatus: ReachabilityStatus { get }

  // MARK: - Requests

  /// Send request expecting JSON response or error
  func request(_ url:      URLConvertible,
               method:     HTTPMethod,
               parameters: Parameters?,
               encoding:   ParameterEncoding,
               headers:    HTTPHeaders?) -> Observable<Data>
}
