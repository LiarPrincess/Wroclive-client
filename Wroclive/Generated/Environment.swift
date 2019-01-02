// Generated using Sourcery 0.15.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length
// swiftlint:disable vertical_whitespace


import Foundation

struct Environment {
  let bundle: BundleManagerType
  let debug: DebugManagerType
  let device: DeviceManagerType
  let log: LogManagerType
  let network: NetworkManagerType
  let schedulers: SchedulersManagerType
  let storage: StorageManagerType
  let userLocation: UserLocationManagerType
  let configuration: Configuration
}
