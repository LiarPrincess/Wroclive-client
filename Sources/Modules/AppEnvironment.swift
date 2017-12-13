//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

typealias Managers = AppEnvironment

class AppEnvironment {

  // MARK: Stack

  static var app:          AppManager          { return current.app          }
  static var bundle:       BundleManager       { return current.bundle       }
  static var device:       DeviceManager       { return current.device       }
  static var appStore:     AppStoreManager     { return current.appStore     }
  static var notification: NotificationManager { return current.notification }
  static var userDefaults: UserDefaultsManager { return current.userDefaults }
  static var documents:    DocumentsManager    { return current.documents    }

  static var api:          ApiManager          { return current.api          }

  static var search:       SearchManager       { return current.search       }
  static var bookmarks:    BookmarksManager    { return current.bookmarks    }
  static var location:     LocationManager     { return current.location     }
  static var tracking:     TrackingManager     { return current.tracking     }

  static var theme:        ThemeManager        { return current.theme        }

  // MARK: Stack

  private static var stack: [Environment] = []

  private static var current: Environment {
    precondition(stack.any, "Attempting to use empty environment stack.")
    return stack.last!
  }

  static func push(
    app:          AppManager          = app,
    bundle:       BundleManager       = bundle,
    device:       DeviceManager       = device,
    appStore:     AppStoreManager     = appStore,
    notification: NotificationManager = notification,
    userDefaults: UserDefaultsManager = userDefaults,
    documents:    DocumentsManager    = documents,
    api:          ApiManager          = api,
    search:       SearchManager       = search,
    bookmarks:    BookmarksManager    = bookmarks,
    location:     LocationManager     = location,
    tracking:     TrackingManager     = tracking,
    theme:        ThemeManager        = theme) {

    push(Environment(
      app:          app,
      bundle:       bundle,
      device:       device,
      appStore:     appStore,
      notification: notification,
      userDefaults: userDefaults,
      documents:    documents,
      api:          api,
      search:       search,
      bookmarks:    bookmarks,
      location:     location,
      tracking:     tracking,
      theme:        theme))
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
