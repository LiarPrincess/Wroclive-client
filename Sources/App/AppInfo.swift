//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation

enum AppInfo {

  enum Website {
    static let about = "https://www.overcast.fm"
  }

  enum AppStore {
    private static let appId = "888422857"

    static let writeReviewUrl  = "itms-apps://itunes.apple.com/us/app/id\(appId)?action=write-review&mt=8"
    static let shareUrl        = "https://itunes.apple.com/us/app/overcast/id\(appId)?mt=8"
  }

  enum Endpoints {
    private static let server = "139.59.154.250"
    static let lines     = "http://" + server + "/lines"
    static let locations = "http://" + server + "/locations"
  }

  enum Timings {
    static let locationAuthorizationPromptDelay: TimeInterval = 2.0
    static let locationUpdateInterval:           TimeInterval = 5.0

    enum FailedRequestDelay {
      static let lines:    TimeInterval = 2.0
      static let location: TimeInterval = 3.0
    }
  }
}
