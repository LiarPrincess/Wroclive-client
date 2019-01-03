// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import RxSwift

public struct Configuration {
  public let websiteUrl = URL(string: "https://www.overcast.fm")!
  public let appStore   = AppStoreConfiguration(appId: "888422857")
  public let endpoints  = EndpointConfiguration(base: "http://127.0.0.1:3000") // "139.59.154.250"
  public let time       = TimingConfiguration()

  public init() { }
}

public struct AppStoreConfiguration {
  private let appId: String

  public var writeReviewUrl: URL { return URL(string: "itms-apps://itunes.apple.com/us/app/id\(appId)?action=write-review&mt=8")! }
  public var shareUrl:       URL { return URL(string: "https://itunes.apple.com/us/app/overcast/id\(appId)?mt=8")! }

  public init(appId: String) {
    self.appId = appId
  }
}

public struct EndpointConfiguration {
  private let base: String

  public var lines: String { return base + "/lines" }
  public var vehicleLocations: String { return base + "/locations" }

  public init(base: String) {
    self.base = base
  }
}

public struct TimingConfiguration {
  public let locationAuthorizationPromptDelay: TimeInterval = 2.0
  public let vehicleUpdateInterval:            TimeInterval = 5.0
}
