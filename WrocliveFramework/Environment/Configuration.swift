// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

// swiftlint:disable force_unwrapping

public struct Configuration {

  public let websiteUrl: URL
  public let githubUrl: URL
  public let reportErrorRecipient: String

  public let appStore: AppStore
  public let timing: Timing

  public struct AppStore {
    public let url: URL
    public let writeReview: URL

    public init(url: String, writeReview: String) {
      self.url = URL(string: url)!
      self.writeReview = URL(string: writeReview)!
    }
  }

  public struct Timing {
    public let vehicleLocationUpdateInterval: TimeInterval
    public let locationAuthorizationPromptDelay: TimeInterval

    public init(
      vehicleLocationUpdateInterval: TimeInterval,
      locationAuthorizationPromptDelay: TimeInterval
    ) {
      self.vehicleLocationUpdateInterval = vehicleLocationUpdateInterval
      self.locationAuthorizationPromptDelay = locationAuthorizationPromptDelay
    }
  }

  public init(websiteUrl: String,
              githubUrl: String,
              reportErrorRecipient: String,
              appStore: AppStore,
              timing: Timing) {
    self.websiteUrl = URL(string: websiteUrl)!
    self.githubUrl = URL(string: githubUrl)!
    self.reportErrorRecipient = reportErrorRecipient
    self.appStore = appStore
    self.timing = timing
  }
}
