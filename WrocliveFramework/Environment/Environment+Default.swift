// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

public extension Environment {
  static var `default`: Environment {
    return Environment(
      bundle: BundleManager(),
      debug: DebugManager(),
      device: DeviceManager(),
      log: LogManager(),
      network: NetworkManager(),
      schedulers: SchedulersManager(),
      storage: CachedStorageManager(using: StorageManager()),
      userLocation: UserLocationManager(),
      configuration: Configuration()
    )
  }
}
