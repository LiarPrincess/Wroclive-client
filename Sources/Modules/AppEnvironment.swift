//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

typealias Managers = AppEnvironment

class AppEnvironment {

  // MARK: Managers

  static var app:          AppManager          { return current.app          }
  static var device:       DeviceManager       { return current.device       }
  static var appStore:     AppStoreManager     { return current.appStore     }
  static var notification: NotificationManager { return current.notification }
  static var api:          ApiManager          { return current.api          }
  static var tutorial:     TutorialManager     { return current.tutorial     }
  static var search:       SearchManager       { return current.search       }
  static var bookmarks:    BookmarksManager    { return current.bookmarks    }
  static var location:     LocationManager     { return current.location     }
  static var tracking:     TrackingManager     { return current.tracking     }
  static var alert:        AlertManager        { return current.alert        }
  static var theme:        ThemeManager        { return current.theme        }

  // MARK: Stack

  private static var stack:   [Environment] = [Environment()]
  private static var current: Environment { return stack.last! }

  static func push(
    app:          AppManager          = app,
    device:       DeviceManager       = device,
    appStore:     AppStoreManager     = appStore,
    api:          ApiManager          = api,
    search:       SearchManager       = search,
    bookmarks:    BookmarksManager    = bookmarks,
    location:     LocationManager     = location,
    tracking:     TrackingManager     = tracking,
    theme:        ThemeManager        = theme,
    tutorial:     TutorialManager     = tutorial,
    alert:        AlertManager        = alert,
    notification: NotificationManager = notification) {

    push(Environment(
      app:          app,
      device:       device,
      appStore:     appStore,
      notification: notification,
      api:          api,
      search:       search,
      bookmarks:    bookmarks,
      location:     location,
      tracking:     tracking,
      alert:        alert,
      theme:        theme,
      tutorial:     tutorial))
  }

  static func push(_ environment: Environment) {
    stack.append(environment)
  }

  static func pop() {
    guard stack.count > 1 else { return }
    _ = stack.popLast()
  }
}
