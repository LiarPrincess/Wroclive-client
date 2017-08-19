//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit

protocol Endpoint {
  var url:               URLConvertible    { get }
  var method:            HTTPMethod        { get }
  var parameterEncoding: ParameterEncoding { get }
  var headers:           HTTPHeaders?      { get }

  associatedtype RequestData
  func encodeParameters(_ data: RequestData) -> Parameters?

  associatedtype ResponseData
  func parseResponse(_ json: Any) -> Promise<ResponseData>
}

// MARK: - Default values

extension Endpoint {
  var method:   HTTPMethod        { return .get }
  var encoding: ParameterEncoding { return URLEncoding.default }
  var headers:  HTTPHeaders?      { return nil }
}
