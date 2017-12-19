//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

class Environment {

  var app:          AppManager
  var device:       DeviceManager
  var network:      NetworkManager
  var location:     LocationManager
  var notification: NotificationManager
  var userDefaults: UserDefaultsManager
  var documents:    DocumentsManager

  var theme:     ThemeManager
  var api:       ApiManager
  var search:    SearchManager
  var bookmarks: BookmarksManager
  var tracking:  TrackingManager

  init(
    app:          AppManager          = AppManagerImpl(),
    device:       DeviceManager       = DeviceManagerImpl(),
    network:      NetworkManager      = NetworkManagerImpl(),
    location:     LocationManager     = LocationManagerImpl(),
    notification: NotificationManager = NotificationManagerImpl(),
    userDefaults: UserDefaultsManager = UserDefaultsManagerImpl(),
    documents:    DocumentsManager    = CachedDocumentsManagerImpl(DocumentsManagerImpl()),

    theme:        ThemeManager        = ThemeManagerImpl(),
    api:          ApiManager          = ApiManagerImpl(),
    search:       SearchManager       = SearchManagerImpl(),
    bookmarks:    BookmarksManager    = BookmarksManagerImpl(),
    tracking:     TrackingManager     = TrackingManagerImpl()) {

    self.app           = app
    self.device        = device
    self.network       = network
    self.location      = location
    self.notification  = notification
    self.userDefaults  = userDefaults
    self.documents     = documents

    self.theme         = theme
    self.api           = api
    self.search        = search
    self.bookmarks     = bookmarks
    self.tracking      = tracking
  }
}
