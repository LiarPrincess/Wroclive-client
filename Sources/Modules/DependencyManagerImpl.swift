//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

class DependencyManagerImpl: DependencyManager {

  let search:       SearchManager       = SearchManagerImpl()
  let bookmarks:    BookmarksManager    = BookmarksManagerImpl()
  let alert:        AlertManager        = AlertManagerImpl()
  let tutorial:     TutorialManager     = TutorialManagerImpl()

  let app:          AppManager          = AppManagerImpl()
  let notification: NotificationManager = NotificationManagerImpl()
  let device:       DeviceManager       = DeviceManagerImpl()
  let appstore:     AppStoreManager     = AppStoreManagerImpl()

  lazy var location: LocationManager = LocationManagerImpl(notificationManager: self.notification)
  lazy var tracking: TrackingManager = TrackingManagerImpl(networkManager: self.network, notificationManager: self.notification)

  lazy var theme:    ThemeManager    = ThemeManagerImpl(notificationManager: self.notification)
  lazy var network:  NetworkManager  = NetworkManagerImpl(appManager: self.app, deviceManager: self.device)
}
