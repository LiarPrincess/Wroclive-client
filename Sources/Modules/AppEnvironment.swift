// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

enum AppEnvironment {

  private static var stack: [Environment] = []

  static var current: Environment {
    precondition(stack.any, "Attempting to use empty environment stack.")
    return stack.last!
  }

  static func pushDefault() {
    push(bundle:        BundleManager(),
         device:       DeviceManager(),
         theme:        ThemeManager(),
         storage:      StorageManager(),
         variables:    EnvironmentVariables(),
         schedulers:   SchedulerManager(),
         api:          ApiManager(),
         live:         LiveManager(),
         network:      NetworkManager(),
         userLocation: UserLocationManager(),
         debug:        DebugManager())
  }

  static func push(bundle:       BundleManagerType       = current.bundle,
                   device:       DeviceManagerType       = current.device,
                   theme:        ThemeManagerType        = current.theme,
                   storage:      StorageManagerType      = current.storage,
                   variables:    EnvironmentVariables    = current.variables,
                   schedulers:   SchedulerManagerType    = current.schedulers,
                   api:          ApiManagerType          = current.api,
                   live:         LiveManagerType         = current.live,
                   network:      NetworkManagerType      = current.network,
                   userLocation: UserLocationManagerType = current.userLocation,
                   debug:        DebugManagerType        = current.debug) {
    push(Environment(bundle: bundle,
                     device: device,
                     theme: theme,
                     storage: storage,
                     variables: variables,
                     schedulers: schedulers,
                     api: api,
                     live: live,
                     network: network,
                     userLocation: userLocation,
                     debug: debug))
  }

  static func push(_ environment: Environment) {
    stack.append(environment)
  }

  static func pop() {
    _ = stack.popLast()
  }
}
