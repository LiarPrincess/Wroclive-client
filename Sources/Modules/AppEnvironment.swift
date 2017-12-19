//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

typealias Managers = AppEnvironment

enum AppEnvironment {

  // MARK: Managers

  static var app:          AppManager          { return current.app }
  static var device:       DeviceManager       { return current.device }
  static var network:      NetworkManager      { return current.network }
  static var location:     LocationManager     { return current.location }
  static var notification: NotificationManager { return current.notification }
  static var userDefaults: UserDefaultsManager { return current.userDefaults }
  static var documents:    DocumentsManager    { return current.documents }

  static var theme:        ThemeManager        { return current.theme }
  static var api:          ApiManager          { return current.api }
  static var search:       SearchManager       { return current.search }
  static var bookmarks:    BookmarksManager    { return current.bookmarks }
  static var tracking:     TrackingManager     { return current.tracking }

  // MARK: Stack

  private static var stack: [Environment] = []

  private static var current: Environment {
    precondition(stack.any, "Attempting to use empty environment stack.")
    return stack.last!
  }

  static func push(
    app:          AppManager          = app,
    device:       DeviceManager       = device,
    network:      NetworkManager      = network,
    location:     LocationManager     = location,
    notification: NotificationManager = notification,
    userDefaults: UserDefaultsManager = userDefaults,
    documents:    DocumentsManager    = documents,

    theme:        ThemeManager        = theme,
    api:          ApiManager          = api,
    search:       SearchManager       = search,
    bookmarks:    BookmarksManager    = bookmarks,
    tracking:     TrackingManager     = tracking) {

    push(Environment(
      app:           app,
      device:        device,
      network:       network,
      location:      location,
      notification:  notification,
      userDefaults:  userDefaults,
      documents:     documents,

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
