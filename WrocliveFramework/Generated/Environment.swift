// Generated using Sourcery 0.15.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length
// swiftlint:disable vertical_whitespace


import Foundation

public class Environment {
  public let bundle: BundleManagerType
  public let debug: DebugManagerType
  public let device: DeviceManagerType
  public let log: LogManagerType
  public let network: NetworkManagerType
  public let schedulers: SchedulersManagerType
  public let storage: StorageManagerType
  public let userLocation: UserLocationManagerType
  public let configuration: Configuration

  public init(
    bundle: BundleManagerType,
    debug: DebugManagerType,
    device: DeviceManagerType,
    log: LogManagerType,
    network: NetworkManagerType,
    schedulers: SchedulersManagerType,
    storage: StorageManagerType,
    userLocation: UserLocationManagerType,
    configuration: Configuration) {

    self.bundle = bundle
    self.debug = debug
    self.device = device
    self.log = log
    self.network = network
    self.schedulers = schedulers
    self.storage = storage
    self.userLocation = userLocation
    self.configuration = configuration
  }
}
