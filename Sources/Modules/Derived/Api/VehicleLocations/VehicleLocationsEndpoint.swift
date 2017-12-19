//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
import Alamofire

class VehicleLocationsEndpoint: Endpoint {

  // MARK: - Properties

  let url:               URLConvertible    = AppInfo.Endpoints.locations
  let method:            HTTPMethod        = .post
  let parameterEncoding: ParameterEncoding = JSONEncoding.default
  let headers:           HTTPHeaders?      = ["Accept": "application/json"]

  // MARK: - Request

  func encodeParameters(_ data: [Line]) -> Parameters? {
    var parameters      = Parameters()
    parameters["lines"] = VehicleLocationsRequest.encode(data)
    return parameters
  }

  // MARK: - Response

  typealias ResponseParser = VehicleLocationsResponseParser
}
