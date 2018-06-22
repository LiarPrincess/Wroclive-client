// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import Alamofire
import RxSwift
import Result

protocol Endpoint {
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
  func sendRequest(data: ParameterData) -> ApiResponse<ResponseData> {
    return AppEnvironment.network
      .request(
        self.url,
        method:     self.method,
        parameters: self.encodeParameters(data),
        encoding:   self.parameterEncoding,
        headers:    self.headers
      )
      .map(self.decodeResponse)
      .map { .success($0) }
      .catchError { self.toApiError($0).map { .failure($0) }}
      .share(replay: 1)
  }

  private func toApiError(_ error: Error) -> Observable<ApiError> {
    switch error {
    case ApiError.invalidResponse: return Observable.just(.invalidResponse)
    default:
      return AppEnvironment.network.reachability.map {
        switch $0 {
        case .none:            return .noInternet
        case .wifi, .cellular: return .generalError
        }
      }
    }
  }

  // Just an commonly used method
  func parseJSON<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
    do {
      let decoder = JSONDecoder()
      return try decoder.decode(T.self, from: data)
    }
    catch {
      throw ApiError.invalidResponse
    }
  }
}

extension Endpoint where ParameterData == Void {
  func encodeParameters(_ data: ParameterData) -> Parameters? {
    return nil
  }

  func sendRequest() -> ApiResponse<ResponseData> {
    return self.sendRequest(data: ())
  }
}
