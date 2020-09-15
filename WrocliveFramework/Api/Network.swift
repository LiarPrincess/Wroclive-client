// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import Alamofire
import PromiseKit

// MARK: - NetworkType

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

// MARK: - Network

public final class Network: NetworkType {

  private let session: Session
  private let reachability: NetworkReachabilityManager?

  public convenience init() {
    self.init(configuration: URLSessionConfiguration.af.default)
  }

  public init(configuration: URLSessionConfiguration) {
    let retryPolicy = Self.createRetryPolicy(retryLimit: 3)
    self.session = Session(configuration: configuration, interceptor: retryPolicy)

    self.reachability = NetworkReachabilityManager()
  }

  private static func createRetryPolicy(retryLimit: UInt) -> RetryPolicy {
    return RetryPolicy(
      retryLimit: 3,
      exponentialBackoffBase: RetryPolicy.defaultExponentialBackoffBase,
      exponentialBackoffScale: RetryPolicy.defaultExponentialBackoffScale,
      retryableHTTPMethods: RetryPolicy.defaultRetryableHTTPMethods,
      retryableHTTPStatusCodes: RetryPolicy.defaultRetryableHTTPStatusCodes,
      retryableURLErrorCodes: RetryPolicy.defaultRetryableURLErrorCodes
    )
  }

  // MARK: - Request

  public func request(url: URLConvertible,
                      method: HTTPMethod,
                      parameters: Parameters?,
                      encoding: ParameterEncoding,
                      headers: HTTPHeaders?) -> Promise<Data> {
    return Promise<Data> { seal in
      let request = self.session.request(
        url,
        method: method,
        parameters: parameters,
        encoding: encoding,
        headers: headers
      )

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

  // MARK: - Reachability status

  public func getReachabilityStatus() -> ReachabilityStatus {
    guard let status = self.reachability?.status else {
      return .unknown
    }

    switch status {
    case .reachable(let connection):
      switch connection {
      case .cellular:
        return .cellular
      case .ethernetOrWiFi:
        return .wifi
      }
    case .notReachable:
      return .unavailable
    case .unknown:
      return .unknown
    }
  }

  // MARK: - Network activity indicator

  public func setNetworkActivityIndicatorVisibility(isVisible: Bool) {
    if #available(iOS 13.0, *) {
      // Network activity indicator is depreciated in iOS 13.
    } else {
      UIApplication.shared.isNetworkActivityIndicatorVisible = isVisible
    }
  }
}
