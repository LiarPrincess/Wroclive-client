//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

protocol Environment {

  // device
  var app:          AppManager          { get }
  var bundle:       BundleManager       { get }
  var device:       DeviceManager       { get }
  var appStore:     AppStoreManager     { get }
  var notification: NotificationManager { get }
  var userDefaults: UserDefaultsManager { get }
  var fileSystem:   FileSystemManager   { get }

  // api
  var api: ApiManager { get }

  // func
  var tutorial:  TutorialManager  { get }
  var search:    SearchManager    { get }
  var bookmarks: BookmarksManager { get }
  var location:  LocationManager  { get }
  var tracking:  TrackingManager  { get }
  var alert:     AlertManager     { get }

  // theme
  var theme: ThemeManager { get }
}

extension Environment {
  static var `default`: Environment { return DefaultEnvironment() }
}

class DefaultEnvironment: Environment {
  lazy var app:          AppManager           = AppManagerImpl()
  lazy var bundle:       BundleManager        = BundleManagerImpl()
  lazy var device:       DeviceManager        = DeviceManagerImpl()
  lazy var appStore:     AppStoreManager      = AppStoreManagerImpl()
  lazy var notification: NotificationManager  = NotificationManagerImpl()
  lazy var userDefaults: UserDefaultsManager  = UserDefaults.standard
  lazy var fileSystem:   FileSystemManager    = FileSystemManagerImpl()
  lazy var api:          ApiManager           = ApiManagerImpl()
  lazy var search:       SearchManager        = SearchManagerImpl()
  lazy var bookmarks:    BookmarksManager     = BookmarksManagerImpl()
  lazy var location:     LocationManager      = LocationManagerImpl()
  lazy var tracking:     TrackingManager      = TrackingManagerImpl()
  lazy var tutorial:     TutorialManager      = TutorialManagerImpl()
  lazy var alert:        AlertManager         = AlertManagerImpl()
  lazy var theme:        ThemeManager         = ThemeManagerImpl()
}

class EnvironmentImpl: Environment {

  let app:          AppManager
  let bundle:       BundleManager
  let device:       DeviceManager
  let appStore:     AppStoreManager
  let notification: NotificationManager
  let userDefaults: UserDefaultsManager
  let fileSystem:   FileSystemManager
  let api:          ApiManager
  let tutorial:     TutorialManager
  let search:       SearchManager
  let bookmarks:    BookmarksManager
  let location:     LocationManager
  let tracking:     TrackingManager
  let alert:        AlertManager
  let theme:        ThemeManager

  init(
    app:          AppManager,
    bundle:       BundleManager,
    device:       DeviceManager,
    appStore:     AppStoreManager,
    notification: NotificationManager,
    userDefaults: UserDefaultsManager,
    fileSystem:   FileSystemManager,
    api:          ApiManager,
    search:       SearchManager,
    bookmarks:    BookmarksManager,
    location:     LocationManager,
    tracking:     TrackingManager,
    tutorial:     TutorialManager,
    alert:        AlertManager,
    theme:        ThemeManager) {

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
