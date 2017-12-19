//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
import Alamofire

class AvailableLinesEndpoint: Endpoint {

  let url:               URLConvertible    = AppInfo.Endpoints.lines
  let method:            HTTPMethod        = .get
  let parameterEncoding: ParameterEncoding = JSONEncoding.default
  let headers:           HTTPHeaders?      = ["Accept": "application/json"]

  typealias ParameterEncoder = EmptyParameterEncoder
  typealias ResponseParser   = AvailableLinesResponseParser
}
