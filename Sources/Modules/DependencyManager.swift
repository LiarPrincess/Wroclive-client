//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

protocol HasLocationManager     { var location:     LocationManager     { get } }
protocol HasSearchManager       { var search:       SearchManager       { get } }
protocol HasBookmarksManager    { var bookmarks:    BookmarksManager    { get } }
protocol HasTrackingManager     { var tracking:     TrackingManager     { get } }
protocol HasAlertManager        { var alert:        AlertManager        { get } }
protocol HasNetworkManager      { var network:      NetworkManager      { get } }
protocol HasAppManager          { var app:          AppManager          { get } }
protocol HasNotificationManager { var notification: NotificationManager { get } }
protocol HasDeviceManager       { var device:       DeviceManager       { get } }
protocol HasAppStoreManager     { var appstore:     AppStoreManager     { get } }
protocol HasThemeManager        { var theme:        ThemeManager        { get } }

protocol DependencyManager:
  HasLocationManager,
  HasSearchManager,
  HasBookmarksManager,
  HasTrackingManager,
  HasAlertManager,
  HasNetworkManager,
  HasAppManager,
  HasNotificationManager,
  HasDeviceManager,
  HasAppStoreManager,
  HasThemeManager
{ }
