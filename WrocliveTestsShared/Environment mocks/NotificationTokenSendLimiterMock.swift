// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import WrocliveFramework

public final class NotificationTokenSendLimiterMock: NotificationTokenSendLimiterType {

  public init() {}

  public var shouldSendResult = false
  public private(set) var shouldSendTokenArg: String?
  public private(set) var shouldSendCallCount = 0

  public func shouldSend(token: String) -> Bool {
    self.shouldSendCallCount += 1
    self.shouldSendTokenArg = token
    return self.shouldSendResult
  }

  public private(set) var registerSendCallCount = 0
  public private(set) var registerSendTokenArg: String?

  public func registerSend(token: String) {
    self.registerSendCallCount += 1
    self.registerSendTokenArg = token
  }
}
