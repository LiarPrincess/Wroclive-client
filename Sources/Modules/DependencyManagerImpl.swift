//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

struct DependencyManagerImpl: DependencyManager {
  let location:     LocationManager     = LocationManagerImpl()
  let search:       SearchManager       = SearchManagerImpl()
  let bookmarks:    BookmarksManager    = BookmarksManagerImpl()
  let tracking:     TrackingManager     = TrackingManagerImpl()
  let alert:        AlertManager        = AlertManagerImpl()
  let network:      NetworkManager      = NetworkManagerImpl()
  let app:          AppManager          = AppManagerImpl()
  let notification: NotificationManager = NotificationManagerImpl()
  let device:       DeviceManager       = DeviceManagerImpl()
  let appstore:     AppStoreManager     = AppStoreManagerImpl()
  let theme:        ThemeManager        = ThemeManagerImpl()
}
