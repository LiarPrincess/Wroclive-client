// Generated using Sourcery 0.13.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.


import Foundation
import os.log

struct Environment {
  let api: ApiManagerType
  let bundle: BundleManagerType
  let debug: DebugManagerType
  let device: DeviceManagerType
  let schedulers: SchedulersManagerType
  let storage: StorageManagerType
  let userLocation: UserLocationManagerType
  let variables: EnvironmentVariables
}