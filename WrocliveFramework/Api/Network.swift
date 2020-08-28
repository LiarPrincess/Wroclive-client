// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import Alamofire
import PromiseKit
import Reachability

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

  // MARK: - Request

  public func request(url: URLConvertible,
                      method: HTTPMethod,
                      parameters: Parameters?,
                      encoding: ParameterEncoding,
                      headers: HTTPHeaders?) -> Promise<Data> {
    // swiftlint:disable:next trailing_closure
    return self.attempt(
      maxRetryCount: 3,
      delayBeforeRetry: .seconds(1),
      sendRequest: { () in
        self.sendSingleRequest(
          url: url,
          method: method,
          parameters: parameters,
          encoding: encoding,
          headers: headers
        )
      }
    )
  }

  private func sendSingleRequest(url: URLConvertible,
                                 method: HTTPMethod,
                                 parameters: Parameters?,
                                 encoding: ParameterEncoding,
                                 headers: HTTPHeaders?) -> Promise<Data> {
    return Promise<Data> { seal in
      let request = AF.request(url,
                               method: method,
                               parameters: parameters,
                               encoding: encoding,
                               headers: headers)

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

  private func attempt<T>(maxRetryCount: Int,
                          delayBeforeRetry: DispatchTimeInterval = .seconds(1),
                          sendRequest: @escaping () -> Promise<T>) -> Promise<T> {
    var attempts = 0
    func attempt() -> Promise<T> {
      attempts += 1
      return sendRequest().recover { error -> Promise<T> in
        guard attempts < maxRetryCount else {
          throw error
        }

        return after(delayBeforeRetry).then(on: nil, attempt)
      }
    }

    return attempt()
  }

  // MARK: - Reachability status

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

  // MARK: - Network activity indicator

  public func setNetworkActivityIndicatorVisibility(isVisible: Bool) {
    if #available(iOS 13.0, *) {
      // Network activity indicator is depreciated in iOS 13.
    } else {
      UIApplication.shared.isNetworkActivityIndicatorVisible = isVisible
    }
  }
}
