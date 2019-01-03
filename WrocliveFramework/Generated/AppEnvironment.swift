// Generated using Sourcery 0.15.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length
// swiftlint:disable vertical_whitespace

import Foundation


public enum AppEnvironment {
  public static var bundle: BundleManagerType { return current.bundle }
  public static var debug: DebugManagerType { return current.debug }
  public static var device: DeviceManagerType { return current.device }
  public static var log: LogManagerType { return current.log }
  public static var network: NetworkManagerType { return current.network }
  public static var schedulers: SchedulersManagerType { return current.schedulers }
  public static var storage: StorageManagerType { return current.storage }
  public static var userLocation: UserLocationManagerType { return current.userLocation }
  public static var configuration: Configuration { return current.configuration }

  private static var stack: [Environment] = []

  public static var current: Environment {
    precondition(stack.any, "Attempting to use empty environment stack.")
    return stack.last!
  }

  public static func push(
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

  public static func push(_ environment: Environment) {
    stack.append(environment)
  }

  public static func pop() {
    _ = stack.popLast()
  }
}
