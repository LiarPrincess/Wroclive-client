// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import Alamofire
import PromiseKit

// MARK: - Api type

public protocol ApiType {

  /// Get all currently available mpk lines
  func getLines() -> Promise<[Line]>

  /// Get current vehicle locations for selected lines
  func getVehicleLocations(for lines: [Line]) -> Promise<[Vehicle]>
}

// MARK: - Api

public final class Api: ApiType {

  // MARK: - Error

  public enum Error: Swift.Error, CustomStringConvertible {

    /// Recieved response is invalid
    case invalidResponse
    /// No internet connnection?
    case reachabilityError
    /// Other unknown errror
    case otherError(Swift.Error)

    public var description: String {
      switch self {
      case .invalidResponse:
        return "Invalid response"
      case .reachabilityError:
        return "Reachability error"
      case .otherError(let e):
        return "Other error: \(e)"
      }
    }
  }

  // MARK: - Properties + init

  private let network: NetworkType
  private let userAgent: String
  private let linesEndpoint: LinesEndpoint
  private let vehicleLocationsEndpoint: VehicleLocationsEndpoint

  public init(bundle: BundleManagerType,
              device: DeviceManagerType,
              configuration: Configuration,
              network: NetworkType) {
    self.network = network
    self.userAgent = Self.createUserAgent(bundle: bundle, device: device)
    self.linesEndpoint = LinesEndpoint(configuration: configuration)
    self.vehicleLocationsEndpoint = VehicleLocationsEndpoint(configuration: configuration)
  }

  /// `Wroclive/1.0 (pl.nopoint.wroclive; iPhone iOS 10.3.1)`
  private static func createUserAgent(bundle: BundleManagerType,
                                      device: DeviceManagerType) -> String {
    let deviceInfo = "\(device.model) \(device.systemName) \(device.systemVersion)"
    return "\(bundle.name)/\(bundle.version) (\(bundle.identifier); \(deviceInfo))"
  }

  // MARK: - Endpoints

  public func getLines() -> Promise<[Line]> {
    let endpoint = self.linesEndpoint
    return self.sendRequest(endpoint: endpoint, data: ())
  }

  public func getVehicleLocations(for lines: [Line]) -> Promise<[Vehicle]> {
    let endpoint = self.vehicleLocationsEndpoint
    return self.sendRequest(endpoint: endpoint, data: lines)
  }

  // MARK: - Helpers

  private func sendRequest<E: Endpoint>(
    endpoint: E,
    data: E.ParameterData
  ) -> Promise<E.ResponseData> {
    var headers = endpoint.headers ?? [:]
    headers["User-Agent"] = self.userAgent

    let parameters = endpoint.encodeParameters(data)

    return self.network
      .request(url:        endpoint.url,
               method:     endpoint.method,
               parameters: parameters,
               encoding:   endpoint.parameterEncoding,
               headers:    headers)
      .map { try endpoint.decodeResponse($0) }
      .recover { error -> Promise<E.ResponseData> in
        throw self.toApiError(error: error)
      }
  }

  private func toApiError(error: Swift.Error) -> Error {
    switch error {
    case Error.invalidResponse:
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
