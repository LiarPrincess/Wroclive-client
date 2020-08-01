// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

public struct Configuration {

  public let websiteUrl: URL
  public let appStore:   AppStore
  public let endpoints:  Endpoints
  public let timing:     Timing

  public struct AppStore {
    public let shareUrl: URL
    public let writeReviewUrl: URL
  }

  public struct Endpoints {
    public let lines: String
    public let vehicleLocations: String
  }

  public struct Timing {
    public let vehicleUpdateInterval: TimeInterval
    public let locationAuthorizationPromptDelay: TimeInterval
  }

  public init() {
    self.websiteUrl = URL(string: "https://www.overcast.fm")!

    let appId = "888422857"
    let share = "https://itunes.apple.com/us/app/overcast/id\(appId)?mt=8" // TODO: overcast
    let writeReview = "itms-apps://itunes.apple.com/us/app/id\(appId)?action=write-review&mt=8"
    self.appStore = AppStore(
      shareUrl: URL(string: share)!,
      writeReviewUrl: URL(string: writeReview)!
    )

    self.timing = Timing(
      vehicleUpdateInterval: 5.0,
      locationAuthorizationPromptDelay: 2.0
    )

    let baseUrl = "http://127.0.0.1:3000" // "139.59.154.250"
    self.endpoints = Endpoints(
      lines: baseUrl + "/lines",
      vehicleLocations: baseUrl + "/locations"
    )
  }
}
