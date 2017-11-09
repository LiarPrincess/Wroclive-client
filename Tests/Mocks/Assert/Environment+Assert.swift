//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

extension Environment {

  static var assert: Environment {
    return Environment(
      app:          AppManagerAssert(),
      bundle:       BundleManagerAssert(),
      device:       DeviceManagerAssert(),
      appStore:     AppStoreManagerAssert(),
      notification: NotificationManagerAssert(),
      userDefaults: UserDefaultsManagerAssert(),
      documents:    DocumentsManagerAssert(),
      api:          ApiManagerAssert(),
      search:       SearchManagerAssert(),
      bookmarks:    BookmarksManagerAssert(),
      location:     LocationManagerAssert(),
      tracking:     TrackingManagerAssert(),
      tutorial:     TutorialManagerAssert(),
      alert:        AlertManagerAssert(),
      theme:        ThemeManagerAssert())
  }
}
