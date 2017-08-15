//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit

class VehicleLocationEndpoint: Endpoint {

  // MARK: - Properties

  let url:               URLConvertible    = "http://192.168.1.100:8080/locations"
  let method:            HTTPMethod        = .post
  let parameterEncoding: ParameterEncoding = JSONEncoding.default
  let headers:           HTTPHeaders?      = ["Accept": "application/json"]

  // MARK: - Request

  func encodeParameters(_ data: [Line]) -> Parameters? {
    var parameters      = Parameters()
    parameters["lines"] = self.encodeLines(data)
    return parameters
  }

  private func encodeLines(_ lines: [Line]) -> [[String:Any]] {
    return lines.map { line in
      return ["name": line.name,
              "type": line.type == .bus ? "bus" : "tram"
      ]
    }
  }

  // MARK: - Response

  func parseResponse(_ json: Any) -> Promise<[Vehicle]> {
    guard let jsonArray = json as? JSONArray else {
      return Promise(error: NetworkError.invalidResponse)
    }

    return Promise { fulfill, reject in
      do {
        let locations = try jsonArray.flatMap { return try LineLocationsParser.parse($0) }
        fulfill(locations)
      } catch {
        reject(NetworkError.invalidResponse)
      }
    }
  }
}
