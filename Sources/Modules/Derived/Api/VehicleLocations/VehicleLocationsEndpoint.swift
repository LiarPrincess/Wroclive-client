//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
import Alamofire

class VehicleLocationsEndpoint: Endpoint {
  let url:               URLConvertible    = AppInfo.Endpoints.locations
  let method:            HTTPMethod        = .post
  let parameterEncoding: ParameterEncoding = JSONEncoding.default
  let headers:           HTTPHeaders?      = ["Accept": "application/json"]

  typealias ParameterEncoder = VehicleLocationsParameterEncoder
  typealias ResponseParser   = VehicleLocationsResponseParser
}
