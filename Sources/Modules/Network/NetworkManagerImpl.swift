//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireNetworkActivityIndicator
import PromiseKit

typealias JSONDictionary =  [String : AnyObject]
typealias JSONArray      = [[String : AnyObject]]

class NetworkManagerImpl: NetworkManager {

  // MARK: - Properties

  private lazy var reachability = Alamofire.NetworkReachabilityManager(host: "www.google.com")

  private lazy var session: SessionManager = {
    var headers = Alamofire.SessionManager.defaultHTTPHeaders
    headers["User-Agent"] = NetworkManagerImpl.createUserAgentString()

    let configuration = URLSessionConfiguration.default
    configuration.httpAdditionalHeaders = headers
    return SessionManager(configuration: configuration)
  }()

  // MARK: - Init

  init() {
    NetworkActivityIndicatorManager.shared.isEnabled = true
    self.reachability?.startListening()
  }

  // MARK: - NetworkManager

  func getAvailableLines() -> Promise<[Line]> {
    let endpoint = AvailableLinesEndpoint()
    return self.sendRequest(endpoint: endpoint, data: ())
  }

  func getVehicleLocations(for lines: [Line]) -> Promise<[Vehicle]> {
    let endpoint = VehicleLocationEndpoint()
    return self.sendRequest(endpoint: endpoint, data: lines)
  }

  // MARK: - Private - Send request

  private func sendRequest<TEndpoint: Endpoint>(endpoint: TEndpoint, data: TEndpoint.RequestData) -> Promise<TEndpoint.ResponseData> {
    return self.session.request(
      endpoint.url,
      method:     endpoint.method,
      parameters: endpoint.encodeParameters(data),
      encoding:   endpoint.parameterEncoding,
      headers:    endpoint.headers
    )
    .validate()
    .responseJSON()
    .then { return endpoint.parseResponse($0) }
    .recover { return self.recover($0) }
  }

  private func recover<T>(_ error: Error) -> Promise<T> {
    switch error {
    case NetworkError.invalidResponse: return Promise(error: error)
    default:
      let isReachable = self.reachability?.isReachable ?? true
      if !isReachable {
        return Promise(error: NetworkError.noInternet)
      }

      return Promise(error: NetworkError.connectionError)
    }
  }

  // MARK: - Private - User agent

  // User-Agent Header; see https://tools.ietf.org/html/rfc7231#section-5.5.3
  // Example: 'Kek/1.0 (com.kekapp.kek; iPhone iOS 10.3.1)'
  private static func createUserAgentString() -> String {
    let deviceOSVersion: String = {
      let model         = Managers.device.model
      let systemName    = Managers.device.systemName
      let systemVersion = Managers.device.systemVersion
      return "\(model) \(systemName) \(systemVersion)"
    }()

    let executable = Managers.app.name
    let appVersion = Managers.app.version
    let bundle     = Managers.app.bundle
    return "\(executable)/\(appVersion) (\(bundle); \(deviceOSVersion))"
  }
}
