// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import Alamofire

internal struct RegisterNotificationTokenEndpoint: Endpoint {

  internal struct ParameterData {
    internal let deviceId: UUID
    internal let token: String
  }

  internal typealias ResponseData = Void

  internal let url: URLConvertible
  internal let method = HTTPMethod.post
  internal let parameterEncoding: ParameterEncoding = JSONEncoding.default
  internal let headers = HTTPHeaders()

  internal init(baseUrl: String) {
    self.url = baseUrl.appendingPathComponent("/notification-tokens")
  }

  internal func encodeParameters(_ data: ParameterData) -> Parameters? {
    var parameters = Parameters()
    parameters["deviceId"] = data.deviceId.uuidString
    parameters["token"] = data.token
    return parameters
  }

  internal func decodeResponse(_ data: Data) throws { }
}
