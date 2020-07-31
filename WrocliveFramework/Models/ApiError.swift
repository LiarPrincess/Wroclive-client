// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

public enum ApiError: Error, Equatable, CustomStringConvertible {

  // TODO: Rename 'noInternet' -> xxx?
  case noInternet
  case invalidResponse
  case generalError

  public var description: String {
    switch self {
    case .noInternet: return "noInternet"
    case .invalidResponse: return "invalidResponse"
    case .generalError: return "generalError"
    }
  }
}
