// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

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
