// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import Alamofire

public protocol Endpoint {
  var url:               URLConvertible    { get }
  var method:            HTTPMethod        { get }
  var parameterEncoding: ParameterEncoding { get }
  var headers:           HTTPHeaders?      { get }

  associatedtype ParameterData
  func encodeParameters(_ data: ParameterData) -> Parameters?

  associatedtype ResponseData
  func decodeResponse(_ data: Data) throws -> ResponseData
}

extension Endpoint {

  internal func parseJSON<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
    do {
      let decoder = JSONDecoder()
      return try decoder.decode(T.self, from: data)
    } catch {
      throw ApiError.invalidResponse
    }
  }
}
