// Generated using Sourcery 0.15.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length
// swiftlint:disable vertical_whitespace

import Foundation


enum AppEnvironment {
  static var bundle: BundleManagerType { return current.bundle }
  static var debug: DebugManagerType { return current.debug }
  static var device: DeviceManagerType { return current.device }
  static var log: LogManagerType { return current.log }
  static var network: NetworkManagerType { return current.network }
  static var schedulers: SchedulersManagerType { return current.schedulers }
  static var storage: StorageManagerType { return current.storage }
  static var userLocation: UserLocationManagerType { return current.userLocation }
  static var configuration: Configuration { return current.configuration }

  private static var stack: [Environment] = []

  static var current: Environment {
    precondition(stack.any, "Attempting to use empty environment stack.")
    return stack.last!
  }

  static func push(
    bundle: BundleManagerType = current.bundle,
    debug: DebugManagerType = current.debug,
    device: DeviceManagerType = current.device,
    log: LogManagerType = current.log,
    network: NetworkManagerType = current.network,
    schedulers: SchedulersManagerType = current.schedulers,
    storage: StorageManagerType = current.storage,
    userLocation: UserLocationManagerType = current.userLocation,
    configuration: Configuration = current.configuration) {

    push(
      Environment(
        bundle: bundle,
        debug: debug,
        device: device,
        log: log,
        network: network,
        schedulers: schedulers,
        storage: storage,
        userLocation: userLocation,
        configuration: configuration
    ))
  }

  static func push(_ environment: Environment) {
    stack.append(environment)
  }

  static func pop() {
    _ = stack.popLast()
  }
}
