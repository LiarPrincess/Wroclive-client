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

  private let reachability = Alamofire.NetworkReachabilityManager(host: "www.google.com")

  private let session: SessionManager = {
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

  func getVehicleLocations(for lines: [Line]) -> Promise<[VehicleLocation]> {
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
      let device = UIDevice.current
      let model         = device.model         // iPhone, iPod touch
      let systemName    = device.systemName    // iOS, watchOS, tvOS
      let systemVersion = device.systemVersion // 1.2
      return "\(model) \(systemName) \(systemVersion)"
    }()

    if let info = Bundle.main.infoDictionary {
      let executable = info[kCFBundleExecutableKey as String] as? String ?? "Unknown"
      let appVersion = info["CFBundleShortVersionString"]     as? String ?? "Unknown"
      let bundle     = info[kCFBundleIdentifierKey as String] as? String ?? "Unknown"
      return "\(executable)/\(appVersion) (\(bundle); \(deviceOSVersion))"
    }

    return deviceOSVersion
  }
}
