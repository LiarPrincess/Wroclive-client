//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
import Alamofire

class AvailableLinesEndpoint: Endpoint {

  // MARK: - Properties

  let url:               URLConvertible    = AppInfo.Endpoints.lines
  let method:            HTTPMethod        = .get
  let parameterEncoding: ParameterEncoding = JSONEncoding.default
  let headers:           HTTPHeaders?      = ["Accept": "application/json"]

  // MARK: - Request

  typealias RequestData  = Void
  func encodeParameters(_ data: RequestData) -> Parameters? {
    return nil
  }

  // MARK: - Response

  typealias ResponseParser = AvailableLinesResponseParser
}
