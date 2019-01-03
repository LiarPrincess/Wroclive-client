// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import Alamofire
import RxSwift
import RxAlamofire
import Reachability

public final class Api: ApiType {
  private lazy var reachability: Reachability? = Reachability()

  // MARK: - ApiManager

  public func getLines() -> Single<[Line]> {
    let endpoint = LinesEndpoint()
    return self.sendRequest(endpoint, ())
  }

  public func getVehicleLocations(for lines: [Line]) -> Single<[Vehicle]> {
    let endpoint = VehicleLocationsEndpoint()
    return self.sendRequest(endpoint, lines)
  }

  private func sendRequest<E: Endpoint>(_ endpoint: E, _ data: E.ParameterData) -> Single<E.ResponseData> {
    return AppEnvironment.network
      .request(url:    endpoint.url,
               method: endpoint.method,
               parameters: endpoint.encodeParameters(data),
               encoding:   endpoint.parameterEncoding,
               headers:    self.withUserAgent(endpoint.headers))
      .validate()
      .data()
      .map { try endpoint.decodeResponse($0) }
      .catchError { throw self.toApiError($0) }
      .asSingle()
  }

  private func withUserAgent(_ headers: HTTPHeaders?) -> HTTPHeaders {
    // 'Wroclive/1.0 (pl.nopoint.wroclive; iPhone iOS 10.3.1)'
    let userAgent: String = {
      let device = AppEnvironment.device
      let bundle = AppEnvironment.bundle

      let deviceInfo = "\(device.model) \(device.systemName) \(device.systemVersion)"
      return "\(bundle.name)/\(bundle.version) (\(bundle.identifier); \(deviceInfo))"
    }()

    var result = headers ?? [:]
    result["User-Agent"] = userAgent
    return result
  }

  private func toApiError(_ error: Error) -> ApiError {
    switch error {
    case ApiError.invalidResponse: return ApiError.invalidResponse
    default:
      // If reachability failed then assume that cellular connection is available
      let connection = self.reachability?.connection ?? Reachability.Connection.cellular
      switch connection {
      case .none: return .noInternet
      default:    return .generalError
      }
    }
  }
}
