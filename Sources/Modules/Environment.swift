//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

class Environment {

  // device
  let app:          AppManager
  let device:       DeviceManager
  let appStore:     AppStoreManager
  let notification: NotificationManager

  // api
  let api: ApiManager

  // func
  let tutorial:  TutorialManager
  let search:    SearchManager
  let bookmarks: BookmarksManager
  let location:  LocationManager
  let tracking:  TrackingManager
  let alert:     AlertManager

  // theme
  let theme: ThemeManager

  init(
    app:          AppManager          = AppManagerImpl(),
    device:       DeviceManager       = DeviceManagerImpl(),
    appStore:     AppStoreManager     = AppStoreManagerImpl(),
    notification: NotificationManager = NotificationManagerImpl(),
    api:          ApiManager          = ApiManagerImpl(),
    search:       SearchManager       = SearchManagerImpl(),
    bookmarks:    BookmarksManager    = BookmarksManagerImpl(),
    location:     LocationManager     = LocationManagerImpl(),
    tracking:     TrackingManager     = TrackingManagerImpl(),
    alert:        AlertManager        = AlertManagerImpl(),
    theme:        ThemeManager        = ThemeManagerImpl(),
    tutorial:     TutorialManager     = TutorialManagerImpl()) {

    self.app           = app
    self.device        = device
    self.appStore      = appStore
    self.api           = api
    self.search        = search
    self.bookmarks     = bookmarks
    self.location      = location
    self.tracking      = tracking
    self.theme         = theme
    self.tutorial      = tutorial
    self.alert         = alert
    self.notification  = notification
  }
}
