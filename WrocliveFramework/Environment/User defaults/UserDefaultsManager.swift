// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

public protocol AppleUserDefaults {
  func string(forKey defaultName: String) -> String?
  func data(forKey defaultName: String) -> Data?
  func setValue(_ value: Any?, forKey key: String)
}

extension UserDefaults: AppleUserDefaults {}

public final class UserDefaultsManager: UserDefaultsManagerType {

  private let userDefaults: AppleUserDefaults

  public init(userDefaults: AppleUserDefaults) {
    self.userDefaults = userDefaults
  }

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

  // MARK: - Notification token

  public func getNotificationToken() -> StoredNotificationToken? {
    guard let data = self.getData(key: .notificationToken) else {
      return nil
    }

    do {
      // 'StoredNotificationToken' should always decode without problems.
      let decoder = JSONDecoder()
      return try decoder.decode(StoredNotificationToken.self, from: data)
    } catch {
      return nil
    }
  }

  public func setNotificationToken(token: StoredNotificationToken) {
    do {
      let encoder = JSONEncoder()
      let data = try encoder.encode(token)
      self.setData(key: .notificationToken, to: data)
    } catch {
      // Ignore, 'StoredNotificationToken' should always encode without problems.
    }
  }

  // MARK: - Helpers - String

  internal struct StringKey {
    internal static let preferredMapType = StringKey("String_preferredMapType")

    internal let value: String

    private init(_ value: String) {
      self.value = value
    }
  }

  private func getString(key: StringKey) -> String? {
    return self.userDefaults.string(forKey: key.value)
  }

  private func setString(key: StringKey, to value: String) {
    self.userDefaults.setValue(value, forKey: key.value)
  }

  // MARK: - Helpers - Data

  internal struct DataKey {
    internal static let notificationToken = DataKey("Data_notificationToken")

    internal let value: String

    private init(_ value: String) {
      self.value = value
    }
  }

  private func getData(key: DataKey) -> Data? {
    return self.userDefaults.data(forKey: key.value)
  }

  private func setData(key: DataKey, to value: Data) {
    self.userDefaults.setValue(value, forKey: key.value)
  }
}
