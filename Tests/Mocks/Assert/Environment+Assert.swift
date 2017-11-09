//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

extension Environment {

  static var assert: Environment {
    return Environment(
//      app:          app,
//      bundle:       bundle,
//      device:       device,
//      appStore:     appStore,
//      notification: notification,
//      userDefaults: userDefaults,
//      documents:    documents,
//      api:          api,
//      search:       search,
      bookmarks:    BookmarksManagerAssert())
//      location:     location,
//      tracking:     tracking,
//      tutorial:     tutorial,
//      alert:        alert,
//      theme:        theme)
  }
}
