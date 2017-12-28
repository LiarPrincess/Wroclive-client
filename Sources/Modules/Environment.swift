//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

class Environment {

  var app:          AppManagerType
  var device:       DeviceManagerType
  var network:      NetworkManagerType
  var location:     LocationManagerType
  var notification: NotificationManagerType
  var userDefaults: UserDefaultsManagerType
  var documents:    DocumentsManagerType

  var theme:     ThemeManagerType
  var api:       ApiManagerType
  var search:    SearchManagerType
  var bookmarks: BookmarksManagerType
  var tracking:  TrackingManagerType

  init(
    app:          AppManagerType          = AppManager(),
    device:       DeviceManagerType       = DeviceManager(),
    network:      NetworkManagerType      = NetworkManager(),
    location:     LocationManagerType     = LocationManager(),
    notification: NotificationManagerType = NotificationManager(),
    userDefaults: UserDefaultsManagerType = UserDefaultsManager(),
    documents:    DocumentsManagerType    = CachedDocumentsManager(DocumentsManager()),

    theme:        ThemeManagerType        = ThemeManager(),
    api:          ApiManagerType          = ApiManager(),
    search:       SearchManagerType       = SearchManager(),
    bookmarks:    BookmarksManagerType    = BookmarksManager(),
    tracking:     TrackingManagerType     = TrackingManager()) {

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
