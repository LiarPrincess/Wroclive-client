// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

public enum UserLocationError: Error, Equatable, CustomStringConvertible {

  case permissionNotDetermined
  case permissionDenied
  case generalError

  public var description: String {
    switch self {
    case .permissionNotDetermined: return "permissionNotDetermined"
    case .permissionDenied: return "permissionDenied"
    case .generalError: return "generalError"
    }
  }
}
