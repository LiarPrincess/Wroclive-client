//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit

extension Endpoint {
  func sendRequest(data: Self.ParameterData) -> Promise<Self.ResponseData> {
    return Managers.network
      .request(
        self.url,
        method:     self.method,
        parameters: Self.ParameterEncoder.encode(data),
        encoding:   self.parameterEncoding,
        headers:    self.headers
      )
      .validate()
      .responseData()
      .then { try Self.ResponseParser.parse($0) }
      .recover { self.recover($0) }
  }

  private func recover<T>(_ error: Error) -> Promise<T> {
    switch error {
    case ApiError.invalidResponse:
      return Promise(error: error)
    default:
      let reachabilityStatus = Managers.network.reachabilityStatus
      switch reachabilityStatus {
      case .notReachable: return Promise(error: ApiError.noInternet)
      case .reachable:    return Promise(error: ApiError.connectionError)
      case .unknown:      return Promise(error: ApiError.connectionError)
      }
    }
  }
}

extension Endpoint where ParameterEncoder.ParameterData == Void {
  func sendRequest() -> Promise<Self.ResponseParser.ResponseData> {
    return self.sendRequest(data: ())
  }
}
