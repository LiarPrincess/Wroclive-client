// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import Alamofire
import PromiseKit
import Reachability

public enum ReachabilityStatus {

  case wifi
  case cellular
  case unavailable
  case unknown

  public var description: String {
    switch self {
    case .cellular:
      return "Cellular"
    case .wifi:
      return "WiFi"
    case .unavailable:
      return "No Connection"
    case .unknown:
      return "Unknown"
    }
  }
}

public protocol NetworkType {

  /// Send network request.
  func request(url: URLConvertible,
               method: HTTPMethod,
               parameters: Parameters?,
               encoding: ParameterEncoding,
               headers: HTTPHeaders?) -> Promise<Data>

  /// Determine the status of a system's current network configuration and the
  /// reachability of a target host.
  ///
  /// A remote host is considered reachable when a data packet, sent by an
  /// application into the network stack, can leave the local device.
  /// Reachability does not guarantee that the data packet will actually be
  /// received by the host.
  func getReachabilityStatus() -> ReachabilityStatus

  /// Show/hide network activity indicator (little circle in the upper left corner).
  func setNetworkActivityIndicatorVisibility(isVisible: Bool)
}

public final class Network: NetworkType {

  private let reachability: Reachability?

  public init() {
    self.reachability = try? Reachability()
  }

  public func request(url: URLConvertible,
                      method: HTTPMethod,
                      parameters: Parameters?,
                      encoding: ParameterEncoding,
                      headers: HTTPHeaders?) -> Promise<Data> {
    // TODO: SessionManager.default.rx.request(method, url, parameters: parameters,
    // encoding: encoding, headers: headers)
    // TODO: NetworkReachabilityManager.default?.startListening { status in
    //  print("Reachability Status Changed: \(status)") }

    let request = AF.request(url,
                             method: method,
                             parameters: parameters,
                             encoding: encoding,
                             headers: headers,
                             interceptor: nil,
                             requestModifier: nil)

    return Promise<Data>() { seal in
      request.responseData { response in
        if let error = response.error {
          seal.reject(error)
        } else if let data = response.data {
          seal.fulfill(data)
        } else {
          fatalError("Network request to '\(url)' was succesfull, but does not contain any data")
        }
      }
    }
  }

  public func getReachabilityStatus() -> ReachabilityStatus {
    guard let status = self.reachability?.connection else {
      return .unknown
    }

    switch status {
    case .wifi:
      return .wifi
    case .cellular:
      return .cellular
    case .unavailable,
         .none: // 'none' is depreciated
      return .unavailable
    }
  }

  public func setNetworkActivityIndicatorVisibility(isVisible: Bool) {
    if #available(iOS 13.0, *) {
      // Network activity indicator is depreciated in iOS 13.
    } else {
      UIApplication.shared.isNetworkActivityIndicatorVisible = isVisible
    }
  }
}
