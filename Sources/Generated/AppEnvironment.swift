// Generated using Sourcery 0.13.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.


enum AppEnvironment {
  static var api: ApiManagerType { return current.api }
  static var bundle: BundleManagerType { return current.bundle }
  static var debug: DebugManagerType { return current.debug }
  static var device: DeviceManagerType { return current.device }
  static var live: LiveManagerType { return current.live }
  static var schedulers: SchedulersManagerType { return current.schedulers }
  static var storage: StorageManagerType { return current.storage }
  static var theme: ThemeManagerType { return current.theme }
  static var userLocation: UserLocationManagerType { return current.userLocation }
  static var variables: EnvironmentVariables { return current.variables }

  private static var stack: [Environment] = []

  private static var current: Environment {
    precondition(stack.any, "Attempting to use empty environment stack.")
    return stack.last!
  }

  static func pushDefault() {
    push(
      api: ApiManager(),
      bundle: BundleManager(),
      debug: DebugManager(),
      device: DeviceManager(),
      live: LiveManager(),
      schedulers: SchedulersManager(),
      storage: StorageManager(),
      theme: ThemeManager(),
      userLocation: UserLocationManager(),
      variables: EnvironmentVariables())
  }

  static func push(
    api: ApiManagerType = current.api,
    bundle: BundleManagerType = current.bundle,
    debug: DebugManagerType = current.debug,
    device: DeviceManagerType = current.device,
    live: LiveManagerType = current.live,
    schedulers: SchedulersManagerType = current.schedulers,
    storage: StorageManagerType = current.storage,
    theme: ThemeManagerType = current.theme,
    userLocation: UserLocationManagerType = current.userLocation,
    variables: EnvironmentVariables) {

    push(Environment(
      api: api,
      bundle: bundle,
      debug: debug,
      device: device,
      live: live,
      schedulers: schedulers,
      storage: storage,
      theme: theme,
      userLocation: userLocation,
      variables: variables))
  }

  static func push(_ environment: Environment) {
    stack.append(environment)
  }

  static func pop() {
    _ = stack.popLast()
  }
}
