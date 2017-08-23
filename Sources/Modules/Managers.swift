//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

struct Managers {
  static var map:       MapManager!
  static var search:    SearchManager!
  static var bookmarks: BookmarksManager!

  static var alert:     AlertManager!
  static var network:   NetworkManager!

  static var app:       AppManager!
  static var device:    DeviceManager!
  static var appStore:  AppStoreManager!

  static var theme:     Theme!

  private init() {}
}
