// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import Alamofire
import RxSwift
import RxAlamofire
import Reachability

class Api: ApiType {
  private let bundle:  BundleManagerType
  private let device:  DeviceManagerType
  private let network: NetworkManagerType

  private lazy var reachability: Reachability? = Reachability()

  init(_ bundle: BundleManagerType, _ device: DeviceManagerType, _ network: NetworkManagerType) {
    self.bundle  = bundle
    self.device  = device
    self.network = network
  }

  // MARK: - ApiManager

  func getAvailableLines() -> Single<[Line]> {
    let endpoint = AvailableLinesEndpoint()
    return self.sendRequest(endpoint, ())
  }

  func getVehicleLocations(for lines: [Line]) -> Single<[Vehicle]> {
    let endpoint = VehicleLocationsEndpoint()
    return self.sendRequest(endpoint, lines)
  }

  private func sendRequest<E: Endpoint>(_ endpoint: E, _ data: E.ParameterData) -> Single<E.ResponseData> {
    return self.network
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
      let deviceInfo = "\(self.device.model) \(self.device.systemName) \(self.device.systemVersion)"
      return "\(self.bundle.name)/\(self.bundle.version) (\(self.bundle.identifier); \(deviceInfo))"
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
