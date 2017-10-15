//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

protocol HasSearchManager       { var search:       SearchManager       { get } }
protocol HasBookmarksManager    { var bookmarks:    BookmarksManager    { get } }
protocol HasLocationManager     { var location:     LocationManager     { get } }
protocol HasTrackingManager     { var tracking:     TrackingManager     { get } }

protocol HasTutorialManager     { var tutorial:     TutorialManager     { get } }
protocol HasAlertManager        { var alert:        AlertManager        { get } }
protocol HasNotificationManager { var notification: NotificationManager { get } }
protocol HasNetworkManager      { var network:      NetworkManager      { get } }

protocol HasAppManager          { var app:          AppManager          { get } }
protocol HasAppStoreManager     { var appStore:     AppStoreManager     { get } }
protocol HasDeviceManager       { var device:       DeviceManager       { get } }

protocol HasThemeManager        { var theme:        ThemeManager        { get } }

protocol DependencyManager:
  HasSearchManager,
  HasBookmarksManager,
  HasLocationManager,
  HasTrackingManager,

  HasTutorialManager,
  HasAlertManager,
  HasNotificationManager,
  HasNetworkManager,

  HasAppManager,
  HasAppStoreManager,
  HasDeviceManager,

  HasThemeManager
{ }
