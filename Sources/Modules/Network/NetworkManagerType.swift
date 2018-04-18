//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

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
