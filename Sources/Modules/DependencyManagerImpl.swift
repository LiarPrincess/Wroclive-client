//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

class DependencyManagerImpl: DependencyManager {

  let search:        SearchManager    = SearchManagerImpl()
  let bookmarks:     BookmarksManager = BookmarksManagerImpl()
  lazy var location: LocationManager  = LocationManagerImpl(notification: self.notification)
  lazy var tracking: TrackingManager  = TrackingManagerImpl(network: self.network, notification: self.notification)

  let tutorial:     TutorialManager     = TutorialManagerImpl()
  let alert:        AlertManager        = AlertManagerImpl()
  let notification: NotificationManager = NotificationManagerImpl()
  lazy var network: NetworkManager      = NetworkManagerImpl(app: self.app, device: self.device)

  let app:          AppManager      = AppManagerImpl()
  let appStore:     AppStoreManager = AppStoreManagerImpl()
  let device:       DeviceManager   = DeviceManagerImpl()

  lazy var theme: ThemeManager = ThemeManagerImpl(notification: self.notification)
}
