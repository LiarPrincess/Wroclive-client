// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import RxSwift

struct EnvironmentVariables {

  let websiteUrl = URL(string: "https://www.overcast.fm")!
  let endpoints = Endpoints()
  let appStore  = AppStore()
  let time      = Time()

  struct Endpoints {
    private let server = "127.0.0.1:3000"// "139.59.154.250"
    var lines:     String { return "http://" + server + "/lines" }
    var locations: String { return "http://" + server + "/locations" }
  }

  struct AppStore {
    private let appId = "888422857"
    var writeReviewUrl: URL { return URL(string: "itms-apps://itunes.apple.com/us/app/id\(appId)?action=write-review&mt=8")! }
    var shareUrl:       URL { return URL(string: "https://itunes.apple.com/us/app/overcast/id\(appId)?mt=8")! }
  }

  struct Time {
    let locationAuthorizationPromptDelay: TimeInterval = 2.0
    let vehicleUpdateInterval:            TimeInterval = 5.0
  }
}
