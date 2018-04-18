//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

class Environment {

  var bundle:       BundleManagerType
  var device:       DeviceManagerType
  var network:      NetworkManagerType
  var userLocation: UserLocationManagerType
  var documents:    DocumentsManagerType
  var debug:        DebugManagerType

  var theme:     ThemeManagerType
  var api:       ApiManagerType
  var search:    SearchManagerType
  var bookmarks: BookmarksManagerType
  var live:      LiveManagerType

  init(
    bundle:       BundleManagerType       = BundleManager(),
    device:       DeviceManagerType       = DeviceManager(),
    network:      NetworkManagerType      = NetworkManager(),
    userLocation: UserLocationManagerType = UserLocationManager(),
    documents:    DocumentsManagerType    = CachedDocumentsManager(DocumentsManager()),
    debug:        DebugManagerType        = DebugManager(),

    theme:     ThemeManagerType     = ThemeManager(),
    api:       ApiManagerType       = ApiManager(),
    search:    SearchManagerType    = SearchManager(),
    bookmarks: BookmarksManagerType = BookmarksManager(),
    live:      LiveManagerType      = LiveManager()) {

    self.bundle        = bundle
    self.device        = device
    self.network       = network
    self.userLocation  = userLocation
    self.documents     = documents
    self.debug         = debug

    self.theme     = theme
    self.api       = api
    self.search    = search
    self.bookmarks = bookmarks
    self.live      = live
  }
}
