// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

struct Environment {
  let bundle: BundleManagerType
  let device: DeviceManagerType

  let theme:      ThemeManagerType
  let storage:    StorageManagerType
  let variables:  EnvironmentVariables
  let schedulers: SchedulerManagerType

  let api:          ApiManagerType
  let live:         LiveManagerType
  let userLocation: UserLocationManagerType

  var debug: DebugManagerType
}
