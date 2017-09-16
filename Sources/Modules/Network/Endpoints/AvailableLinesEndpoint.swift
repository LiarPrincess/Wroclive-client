//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit

class AvailableLinesEndpoint: Endpoint {

  // MARK: - Properties

  let url:               URLConvertible    = AppInfo.Endpoints.lines
  let method:            HTTPMethod        = .get
  let parameterEncoding: ParameterEncoding = JSONEncoding.default
  let headers:           HTTPHeaders?      = ["Accept": "application/json"]

  // MARK: - Request

  func encodeParameters(_ data: Void) -> Parameters? {
    return nil
  }

  // MARK: - Response

  func decodeResponse(_ json: Any) -> Promise<[Line]> {
    guard let jsonArray = json as? JSONArray else {
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
