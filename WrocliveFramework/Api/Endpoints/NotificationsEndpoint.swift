// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import Alamofire

internal struct NotificationsEndpoint: Endpoint {

  internal typealias ParameterData = Void
  internal typealias ResponseData = [Notification]

  internal let url: URLConvertible
  internal let method = HTTPMethod.get
  internal let parameterEncoding: ParameterEncoding = JSONEncoding.default
  internal let headers = HTTPHeaders(accept: .json, acceptEncoding: .compressed)

  internal init(baseUrl: String) {
    self.url = baseUrl.appendingPathComponent("/notifications")
  }

  internal func encodeParameters(_ data: Void) -> Parameters? {
    return nil
  }

  internal func decodeResponse(_ data: Data) throws -> ResponseData {
    let responseModel = try self.parseJSON(ResponseModel.self, from: data)
    let mapResult = self.map(models: responseModel.data, fn: parseNotification(model:))

    switch mapResult {
    case .noModels:
      return []
    case .success(let notifications):
      return notifications
    case .partialSuccess(let notifications):
      // Some of them failed, but it is better than nothing.
      return notifications
    case .allFailed:
      throw ApiError.invalidResponse
    }
  }
}

// MARK: - Response

private struct ResponseModel: Decodable {
  let timestamp: String
  let data: [NotificationModel]
}

private struct NotificationModel: Decodable {
  let id: String
  let url: String
  let author: String
  let date: String
  let body: String
}

private func parseNotification(model: NotificationModel) -> Notification? {
  guard let date = Date(iso8601: model.date) else {
    return nil
  }

  return Notification(
    id: model.id,
    url: model.url,
    author: model.author,
    date: date,
    body: model.body
  )
}
