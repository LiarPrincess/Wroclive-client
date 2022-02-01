// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import Alamofire
import PromiseKit

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
