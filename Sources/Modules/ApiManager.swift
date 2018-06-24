// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import Result
import Alamofire
import AlamofireNetworkActivityIndicator
import RxSwift
import RxAlamofire
import Reachability

class ApiManager: ApiManagerType {

  private lazy var reachability: Reachability? = Reachability()

  private lazy var session: SessionManager = {
    // 'Wroclive/1.0 (pl.nopoint.wroclive; iPhone iOS 10.3.1)'
    let userAgent: String = {
      let device = AppEnvironment.current.device
      let bundle = AppEnvironment.current.bundle

      let deviceInfo = "\(device.model) \(device.systemName) \(device.systemVersion)"
      return "\(bundle.name)/\(bundle.version) (\(bundle.identifier); \(deviceInfo))"
    }()

    let configuration = URLSessionConfiguration.default
    configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
    configuration.httpAdditionalHeaders!["User-Agent"] = userAgent

    return SessionManager(configuration: configuration)
  }()

  init() {
    NetworkActivityIndicatorManager.shared.isEnabled = true
  }

  // MARK: - ApiManager

  var availableLines: ApiResponse<[Line]> {
    let endpoint = AvailableLinesEndpoint()
    return self.sendRequest(endpoint, ())
  }

  func vehicleLocations(for lines: [Line]) -> ApiResponse<[Vehicle]> {
    let endpoint = VehicleLocationsEndpoint()
    return self.sendRequest(endpoint, lines)
  }

  private func sendRequest<E: Endpoint>(_ endpoint: E, _ data: E.ParameterData) -> ApiResponse<E.ResponseData> {
    return self.session.rx
      .request(endpoint.method,
               endpoint.url,
               parameters: endpoint.encodeParameters(data),
               encoding:   endpoint.parameterEncoding,
               headers:    endpoint.headers)
      .validate()
      .data()
      .map { try endpoint.decodeResponse($0) }
      .map { Result.success($0) }
      .catchError { Observable.just(.failure(self.toApiError($0))) }
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
