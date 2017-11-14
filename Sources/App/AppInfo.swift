//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation

struct AppInfo {

  static let website      = "www.nopoint.pl"
  static let websiteHttps = "https://\(website)"

  struct AppStore {
    private static let appId = "888422857"

    static let writeReviewUrl  = "itms-apps://itunes.apple.com/us/app/id\(appId)?action=write-review&mt=8"
    static let shareUrl        = "https://itunes.apple.com/us/app/overcast/id\(appId)?mt=8"
  }

  #if DEBUG
  struct Endpoints {
    static let lines     = "http://192.168.1.100:8080/lines"
    static let locations = "http://192.168.1.100:8080/locations"
  }
  #else
  #endif

  static let locationAuthorizationDelay: TimeInterval = 2.0
  static let locationUpdateInterval:     TimeInterval = 5.0
  static let failedLinesRequestDelay:    TimeInterval = 2.0
  static let failedLocationRequestDelay: TimeInterval = 3.0
}
