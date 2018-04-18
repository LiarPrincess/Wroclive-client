//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

class Environment {

  var bundle: BundleManagerType
  var device: DeviceManagerType

  var theme:   ThemeManagerType
  var storage: StorageManagerType

  var api:          ApiManagerType
  var live:         LiveManagerType
  var network:      NetworkManagerType
  var userLocation: UserLocationManagerType

  var debug: DebugManagerType

  init(
    bundle:       BundleManagerType       = BundleManager(),
    device:       DeviceManagerType       = DeviceManager(),
    theme:        ThemeManagerType        = ThemeManager(),
    storage:      StorageManagerType      = StorageManager(),
    api:          ApiManagerType          = ApiManager(),
    live:         LiveManagerType         = LiveManager(),
    network:      NetworkManagerType      = NetworkManager(),
    userLocation: UserLocationManagerType = UserLocationManager(),
    debug:        DebugManagerType        = DebugManager()) {

    self.bundle = bundle
    self.device = device

    self.theme   = theme
    self.storage = storage

    self.api          = api
    self.live         = live
    self.network      = network
    self.userLocation = userLocation

    self.debug = debug
  }
}
