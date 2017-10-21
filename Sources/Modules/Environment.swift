//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

class Environment {

  // device
  var app:          AppManager
  var bundle:       BundleManager
  var device:       DeviceManager
  var appStore:     AppStoreManager
  var notification: NotificationManager
  var userDefaults: UserDefaultsManager
  var fileSystem:   FileSystemManager

  // api
  var api: ApiManager

  // func
  var tutorial:  TutorialManager
  var search:    SearchManager
  var bookmarks: BookmarksManager
  var location:  LocationManager
  var tracking:  TrackingManager
  var alert:     AlertManager

  // theme
  var theme: ThemeManager

  init(
    app:          AppManager          = AppManagerImpl(),
    bundle:       BundleManager       = BundleManagerImpl(),
    device:       DeviceManager       = DeviceManagerImpl(),
    appStore:     AppStoreManager     = AppStoreManagerImpl(),
    notification: NotificationManager = NotificationManagerImpl(),
    userDefaults: UserDefaultsManager = UserDefaults.standard,
    fileSystem:   FileSystemManager   = FileSystemManagerImpl(),
    api:          ApiManager          = ApiManagerImpl(),
    search:       SearchManager       = SearchManagerImpl(),
    bookmarks:    BookmarksManager    = BookmarksManagerImpl(),
    location:     LocationManager     = LocationManagerImpl(),
    tracking:     TrackingManager     = TrackingManagerImpl(),
    tutorial:     TutorialManager     = TutorialManagerImpl(),
    alert:        AlertManager        = AlertManagerImpl(),
    theme:        ThemeManager        = ThemeManagerImpl()) {

    self.app           = app
    self.bundle        = bundle
    self.device        = device
    self.appStore      = appStore
    self.notification  = notification
    self.userDefaults  = userDefaults
    self.fileSystem    = fileSystem
    self.api           = api
    self.search        = search
    self.bookmarks     = bookmarks
    self.location      = location
    self.tracking      = tracking
    self.tutorial      = tutorial
    self.alert         = alert
    self.theme         = theme
  }
}