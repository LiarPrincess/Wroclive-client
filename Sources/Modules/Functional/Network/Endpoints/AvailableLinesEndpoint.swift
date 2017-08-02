//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit

class AvailableLinesEndpoint: Endpoint {

  // MARK: - Properties

  let url:               URLConvertible    = "http://192.168.1.100:8080/lines"
  let method:            HTTPMethod        = .post
  let parameterEncoding: ParameterEncoding = JSONEncoding.default
  let headers:           HTTPHeaders?      = ["Accept": "application/json"]

  // MARK: - Request

  func encodeParameters(_ data: Void) -> Parameters? {
    var parameters = Parameters()
    parameters["device_id"] = self.getDeviceIdentifier()
    return parameters
  }

  // MARK: - Response

  func parseResponse(_ json: Any) -> Promise<[Line]> {
    guard let jsonArray = json as? [[String:Any]] else {
      return Promise(error: NetworkError.invalidResponse)
    }

    return Promise { fulfill, reject in
      do {
        let locations = try jsonArray.map { return try LinesParser.parse($0) }
        fulfill(locations)
      } catch let error {
        reject(error)
      }
    }
  }
}
