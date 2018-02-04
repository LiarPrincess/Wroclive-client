//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

class Environment {

  var app:          AppManagerType
  var device:       DeviceManagerType
  var network:      NetworkManagerType
  var userLocation: UserLocationManagerType
  var userDefaults: UserDefaultsManagerType
  var documents:    DocumentsManagerType
  var debug:        DebugManagerType

  var theme:     ThemeManagerType
  var api:       ApiManagerType
  var search:    SearchManagerType
  var bookmarks: BookmarksManagerType
  var map:       MapManagerType

  init(
    app:          AppManagerType          = AppManager(),
    device:       DeviceManagerType       = DeviceManager(),
    network:      NetworkManagerType      = NetworkManager(),
    userLocation: UserLocationManagerType = UserLocationManager(),
    userDefaults: UserDefaultsManagerType = UserDefaultsManager(),
    documents:    DocumentsManagerType    = CachedDocumentsManager(DocumentsManager()),
    debug:        DebugManagerType        = DebugManager(),

    theme:     ThemeManagerType     = ThemeManager(),
    api:       ApiManagerType       = ApiManager(),
    search:    SearchManagerType    = SearchManager(),
    bookmarks: BookmarksManagerType = BookmarksManager(),
    map:       MapManagerType       = MapManager()) {

    self.app           = app
    self.device        = device
    self.network       = network
    self.userLocation  = userLocation
    self.userDefaults  = userDefaults
    self.documents     = documents
    self.debug         = debug

    self.theme     = theme
    self.api       = api
    self.search    = search
    self.bookmarks = bookmarks
    self.map       = map
  }
}
