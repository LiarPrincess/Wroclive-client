//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit

class VehicleLocationsEndpoint: Endpoint {

  // MARK: - Properties

  let url:               URLConvertible    = AppInfo.Endpoints.locations
  let method:            HTTPMethod        = .post
  let parameterEncoding: ParameterEncoding = JSONEncoding.default
  let headers:           HTTPHeaders?      = ["Accept": "application/json"]

  // MARK: - Request

  func encodeParameters(_ data: [Line]) -> Parameters? {
    var parameters      = Parameters()
    parameters["lines"] = VehicleLocationsSerialization.encode(data)
    return parameters
  }

  // MARK: - Response

  func decodeResponse(_ json: Any) -> Promise<[Vehicle]> {
    guard let jsonArray = json as? JSONArray else {
      return Promise(error: NetworkError.invalidResponse)
    }

    return Promise { fulfill, reject in
      do {
        let locations = try jsonArray.flatMap { return try VehicleLocationsSerialization.decode($0) }
        fulfill(locations)
      } catch {
        reject(NetworkError.invalidResponse)
      }
    }
  }
}
