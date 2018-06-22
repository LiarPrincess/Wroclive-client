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
  let network:      NetworkManagerType
  let userLocation: UserLocationManagerType

  var debug: DebugManagerType

  init(
    bundle:       BundleManagerType       = BundleManager(),
    device:       DeviceManagerType       = DeviceManager(),
    theme:        ThemeManagerType        = ThemeManager(),
    storage:      StorageManagerType      = StorageManager(),
    variables:    EnvironmentVariables    = EnvironmentVariables(),
    schedulers:   SchedulerManagerType    = SchedulerManager(),
    api:          ApiManagerType          = ApiManager(),
    live:         LiveManagerType         = LiveManager(),
    network:      NetworkManagerType      = NetworkManager(),
    userLocation: UserLocationManagerType = UserLocationManager(),
    debug:        DebugManagerType        = DebugManager()) {

    self.bundle = bundle
    self.device = device

    self.theme      = theme
    self.storage    = storage
    self.variables  = variables
    self.schedulers = schedulers

    self.api          = api
    self.live         = live
    self.network      = network
    self.userLocation = userLocation

    self.debug = debug
  }
}
