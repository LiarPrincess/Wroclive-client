// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

public enum ApiError: Error, CustomStringConvertible {

  /// Recieved response is invalid
  case invalidResponse
  /// No internet connnection?
  case reachabilityError
  /// Other unknown errror
  case otherError(Error)

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
