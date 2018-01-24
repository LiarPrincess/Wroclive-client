//
//  Created by Michal Matuszczyk
//  Copyright © 2018 Michal Matuszczyk. All rights reserved.
//

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
  func decode(_ data: Data) throws -> ResponseData
}

extension Endpoint {
  func sendRequest(data: ParameterData) -> ApiResponse<ResponseData> {
    return Managers.network
      .request(
        self.url,
        method:     self.method,
        parameters: self.encodeParameters(data),
        encoding:   self.parameterEncoding,
        headers:    self.headers
      )
      .map(self.decode)
      .map { .success($0) }
      .catchError { Observable.just(.failure(apiError($0))) }
      .share(replay: 1)
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

private func apiError(_ error: Error) -> ApiError {
  switch error {
  case ApiError.invalidResponse: return .invalidResponse
  default:
    let reachabilityStatus = Managers.network.reachabilityStatus
    switch reachabilityStatus {
    case .notReachable: return .noInternet
    case .reachable,
         .unknown:      return .generalError
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