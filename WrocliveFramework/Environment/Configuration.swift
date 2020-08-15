// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

// swiftlint:disable force_unwrapping

public struct Configuration {

  public let websiteUrl: URL
  public let appStore: AppStore
  public let endpoints: Endpoints
  public let timing: Timing

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

  public init(apiBaseUrl: String,
              websiteUrl: String,
              shareUrl: String,
              writeReviewUrl: String) {
    self.websiteUrl = URL(string: websiteUrl)!

    self.appStore = AppStore(
      shareUrl: URL(string: shareUrl)!,
      writeReviewUrl: URL(string: writeReviewUrl)!
    )

    self.timing = Timing(
      vehicleUpdateInterval: 5.0,
      locationAuthorizationPromptDelay: 2.0
    )

    self.endpoints = Endpoints(
      lines: apiBaseUrl + "/lines",
      vehicleLocations: apiBaseUrl + "/locations"
    )
  }
}
