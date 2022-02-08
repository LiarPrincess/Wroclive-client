// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

// swiftlint:disable force_unwrapping

public struct Configuration {

  public let apiUrl: URL
  public let githubUrl: URL
  public let privacyPolicyUrl: URL
  public let reportErrorMailRecipient: String

  public let appStore: AppStore
  public let timing: Timing

  public struct AppStore {
    public let url: URL
    public let writeReviewUrl: URL

    public init(url: String, writeReviewUrl: String) {
      self.url = URL(string: url)!
      self.writeReviewUrl = URL(string: writeReviewUrl)!
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

  public init(apiUrl: String,
              githubUrl: String,
              privacyPolicyUrl: String,
              reportErrorMailRecipient: String,
              appStore: AppStore,
              timing: Timing) {
    self.apiUrl = URL(string: apiUrl)!
    self.githubUrl = URL(string: githubUrl)!
    self.privacyPolicyUrl = URL(string: privacyPolicyUrl)!
    self.reportErrorMailRecipient = reportErrorMailRecipient
    self.appStore = appStore
    self.timing = timing
  }
}
