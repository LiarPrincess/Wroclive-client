// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

// swiftlint:disable force_unwrapping

public struct Configuration {

  public let websiteUrl: URL
  public let appStore: AppStore
  public let timing: Timing

  public struct AppStore {
    public let shareUrl: URL
    public let writeReviewUrl: URL
  }

  public struct Timing {
    public let vehicleLocationUpdateInterval: TimeInterval
    public let locationAuthorizationPromptDelay: TimeInterval
  }

  public init(websiteUrl: String,
              shareUrl: String,
              writeReviewUrl: String,
              vehicleLocationUpdateInterval: TimeInterval,
              locationAuthorizationPromptDelay: TimeInterval) {
    self.websiteUrl = URL(string: websiteUrl)!

    self.appStore = AppStore(
      shareUrl: URL(string: shareUrl)!,
      writeReviewUrl: URL(string: writeReviewUrl)!
    )

    self.timing = Timing(
      vehicleLocationUpdateInterval: vehicleLocationUpdateInterval,
      locationAuthorizationPromptDelay: locationAuthorizationPromptDelay
    )
  }
}
