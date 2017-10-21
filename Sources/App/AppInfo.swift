//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation

struct AppInfo {

  static let appStoreId = "888422857"

  static let website      = "www.kekapp.pl"
  static let websiteHttps = "https://\(website)"

  #if DEBUG
  struct Endpoints {
    static let lines     = "http://192.168.1.100:8080/lines"
    static let locations = "http://192.168.1.100:8080/locations"
  }
  #else
  #endif

  static let locationUpdateInterval:     TimeInterval = 3.0
  static let failedLinesRequestDelay:    TimeInterval = 2.0
  static let failedLocationRequestDelay: TimeInterval = 3.0
}
