//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

typealias Managers = AppEnvironment

enum AppEnvironment {

  // MARK: Managers

  static var app:          AppManagerType          { return current.app          }
  static var device:       DeviceManagerType       { return current.device       }
  static var network:      NetworkManagerType      { return current.network      }
  static var userLocation: UserLocationManagerType { return current.userLocation }
  static var notification: NotificationManagerType { return current.notification }
  static var userDefaults: UserDefaultsManagerType { return current.userDefaults }
  static var documents:    DocumentsManagerType    { return current.documents    }
  static var debug:        DebugManagerType        { return current.debug        }

  static var theme:        ThemeManagerType        { return current.theme     }
  static var api:          ApiManagerType          { return current.api       }
  static var search:       SearchManagerType       { return current.search    }
  static var bookmarks:    BookmarksManagerType    { return current.bookmarks }
  static var tracking:     TrackingManagerType     { return current.tracking  }

  // MARK: Stack

  private static var stack: [Environment] = []

  private static var current: Environment {
    precondition(stack.any, "Attempting to use empty environment stack.")
    return stack.last!
  }

  static func push(
    app:          AppManagerType          = app,
    device:       DeviceManagerType       = device,
    network:      NetworkManagerType      = network,
    userLocation: UserLocationManagerType = userLocation,
    notification: NotificationManagerType = notification,
    userDefaults: UserDefaultsManagerType = userDefaults,
    documents:    DocumentsManagerType    = documents,
    debug:        DebugManagerType        = debug,

    theme:        ThemeManagerType        = theme,
    api:          ApiManagerType          = api,
    search:       SearchManagerType       = search,
    bookmarks:    BookmarksManagerType    = bookmarks,
    tracking:     TrackingManagerType     = tracking) {

    push(Environment(
      app:           app,
      device:        device,
      network:       network,
      userLocation:  userLocation,
      notification:  notification,
      userDefaults:  userDefaults,
      documents:     documents,
      debug:         debug,

      theme:         theme,
      api:           api,
      search:        search,
      bookmarks:     bookmarks,
      tracking:      tracking))
  }

  static func push(_ environment: Environment) {
    stack.append(environment)
  }

  static func pop() {
    precondition(stack.any, "Attempting to clear empty environment stack.")
    precondition(stack.count > 1, "Attempting to illegaly clear environment stack.")
    _ = stack.popLast()
  }
}
