//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

struct Managers {
  static var location:     LocationManager!
  static var search:       SearchManager!
  static var bookmarks:    BookmarksManager!
  static var tracking:     TrackingManager!

  static var alert:        AlertManager!
  static var network:      NetworkManager!

  static var app:          AppManager!
  static var notification: NotificationManager!
  static var device:       DeviceManager!
  static var appStore:     AppStoreManager!

  static var theme:        ThemeManager!

  private init() {}
}
