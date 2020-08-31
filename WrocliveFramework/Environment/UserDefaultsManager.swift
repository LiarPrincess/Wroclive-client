// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

public protocol UserDefaultsManagerType {
  func getPreferredMapType() -> MapType?
  func setPreferredMapType(mapType: MapType)
}

public struct UserDefaultsManager: UserDefaultsManagerType {

  private enum Key: String {
    case preferredMapType = "String_preferredMapType"
  }

  private let defaults = UserDefaults.standard

  // MARK: - Preferred map type

  public func getPreferredMapType() -> MapType? {
    guard let string = self.getString(key: .preferredMapType) else {
      return nil
    }

    switch string {
    case "standard": return .standard
    case "satellite": return .satellite
    case "hybrid": return .hybrid
    default: return nil
    }
  }

  public func setPreferredMapType(mapType: MapType) {
    let string: String
    switch mapType {
    case .standard: string = "standard"
    case .satellite: string = "satellite"
    case .hybrid: string = "hybrid"
    }

    self.setString(key: .preferredMapType, to: string)
  }

  // MARK: - Helpers

  private func getString(key: Key) -> String? {
    return self.defaults.string(forKey: key.rawValue)
  }

  private func setString(key: Key, to value: String) {
    self.defaults.setValue(value, forKey: key.rawValue)
  }
}
