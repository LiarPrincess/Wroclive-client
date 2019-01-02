// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import RxSwift

struct Configuration {
  let websiteUrl = URL(string: "https://www.overcast.fm")!
  let appStore   = AppStoreConfiguration(appId: "888422857")
  let endpoints  = EndpointConfiguration(base: "http://127.0.0.1:3000") // "139.59.154.250"
  let time       = TimingConfiguration()
}

struct AppStoreConfiguration {
  private let appId: String

  var writeReviewUrl: URL { return URL(string: "itms-apps://itunes.apple.com/us/app/id\(appId)?action=write-review&mt=8")! }
  var shareUrl:       URL { return URL(string: "https://itunes.apple.com/us/app/overcast/id\(appId)?mt=8")! }

  init(appId: String) {
    self.appId = appId
  }
}

struct EndpointConfiguration {
  private let base: String

  var lines: String { return base + "/lines" }
  var vehicleLocations: String { return base + "/locations" }

  init(base: String) {
    self.base = base
  }
}

struct TimingConfiguration {
  let locationAuthorizationPromptDelay: TimeInterval = 2.0
  let vehicleUpdateInterval:            TimeInterval = 5.0
}
