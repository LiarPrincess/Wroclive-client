// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import os.log
import Alamofire
import PromiseKit

public final class Api: ApiType {

  private let userAgent: String
  private let linesEndpoint: LinesEndpoint
  private let vehicleLocationsEndpoint: VehicleLocationsEndpoint
  private let network: NetworkType
  private let logManager: LogManagerType

  private var log: OSLog {
    return self.logManager.api
  }

  // MARK: - Init

  public init(baseUrl: String,
              network: NetworkType,
              bundle: BundleManagerType,
              device: DeviceManagerType,
              log: LogManagerType) {
    self.network = network
    self.logManager = log
    self.userAgent = Self.createUserAgent(bundle: bundle, device: device)

    let baseUrl = baseUrl.appendingPathComponent("/v1")
    self.linesEndpoint = LinesEndpoint(baseUrl: baseUrl)
    self.vehicleLocationsEndpoint = VehicleLocationsEndpoint(baseUrl: baseUrl)
  }

  /// `Wroclive/1.0 (pl.nopoint.wroclive; iPhone 5s; iOS 10.3.1)`
  private static func createUserAgent(bundle: BundleManagerType,
                                      device: DeviceManagerType) -> String {
    let deviceInfo = "\(device.model); \(device.systemName) \(device.systemVersion)"
    return "\(bundle.name)/\(bundle.version) (\(bundle.identifier); \(deviceInfo))"
  }

  // MARK: - Endpoints

  public func getLines() -> Promise<[Line]> {
    os_log("Sending 'getLines' request", log: self.log, type: .debug)
    let endpoint = self.linesEndpoint
    return self.sendRequest(endpoint: endpoint, data: ())
  }

  public func getVehicleLocations(for lines: [Line]) -> Promise<[Vehicle]> {
    if lines.isEmpty {
      os_log("No lines requested in 'getVehicleLocations'", log: self.log, type: .debug)
      return .value([])
    }

    os_log("Sending 'getVehicleLocations' request", log: self.log, type: .debug)
    let endpoint = self.vehicleLocationsEndpoint
    return self.sendRequest(endpoint: endpoint, data: lines)
  }

  public func setNetworkActivityIndicatorVisibility(isVisible: Bool) {
    self.network.setNetworkActivityIndicatorVisibility(isVisible: isVisible)
  }

  // MARK: - Helpers

  private func sendRequest<E: Endpoint>(
    endpoint: E,
    data: E.ParameterData
  ) -> Promise<E.ResponseData> {
    var headers = endpoint.headers
    headers["User-Agent"] = headers.value(for: "User-Agent") ?? self.userAgent

    let parameters = endpoint.encodeParameters(data)

    return self.network
      .request(url: endpoint.url,
               method: endpoint.method,
               parameters: parameters,
               encoding: endpoint.parameterEncoding,
               headers: headers)
      .map { try endpoint.decodeResponse($0) }
      .recover { error -> Promise<E.ResponseData> in
        throw self.toApiError(error: error)
      }
  }

  private func toApiError(error: Error) -> ApiError {
    switch error {
    case ApiError.invalidResponse:
      return .invalidResponse

    default:
      let status = self.network.getReachabilityStatus()

      switch status {
      case .unavailable:
        return .reachabilityError
      case .wifi,
           .cellular,
           .unknown:
        return .otherError(error)
      }
    }
  }
}
