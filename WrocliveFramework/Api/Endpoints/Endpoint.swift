// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import Alamofire

// swiftlint:disable discouraged_optional_collection

public protocol Endpoint {
  var url: URLConvertible { get }
  var method: HTTPMethod { get }
  var parameterEncoding: ParameterEncoding { get }
  var headers: HTTPHeaders { get }

  associatedtype ParameterData
  func encodeParameters(_ data: ParameterData) -> Parameters?

  associatedtype ResponseData
  func decodeResponse(_ data: Data) throws -> ResponseData
}

internal enum EndpointMapResult<Result> {
  /// Nothing to map.
  case noModels
  /// All mapped without problems.
  case success([Result])
  /// Some failed.
  case partialSuccess([Result])
  /// ...
  case allFailed
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

  internal func map<ResponseModel, Result>(
    models: [ResponseModel],
    fn: (ResponseModel) -> Result?
  ) -> EndpointMapResult<Result> {
    if models.isEmpty {
      return .noModels
    }

    var result = [Result]()
    result.reserveCapacity(models.count)

    for model in models {
      if let r = fn(model) {
        result.append(r)
      }
    }

    if result.isEmpty {
      return .allFailed
    }

    if result.count != models.count {
      return .partialSuccess(result)
    }

    return .success(result)
  }

  internal func compactMap<ResponseModel, Result>(
    models: [ResponseModel],
    fn: (ResponseModel) -> [Result]?
  ) -> EndpointMapResult<Result> {
    if models.isEmpty {
      return .noModels
    }

    var result = [Result]()
    result.reserveCapacity(models.count)

    var failedCount = 0
    for model in models {
      if let rs = fn(model) {
        result.append(contentsOf: rs)
      } else {
        failedCount += 1
      }
    }

    if failedCount == models.count {
      return .allFailed
    }

    if failedCount != 0 {
      return .partialSuccess(result)
    }

    return .success(result)
  }
}
