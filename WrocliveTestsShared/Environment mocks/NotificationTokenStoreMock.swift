// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import WrocliveFramework

public final class NotificationTokenStoreMock: NotificationTokenStore {

  public init() {}

  public var storedNotificationToken: StoredNotificationToken?
  public private(set) var getNotificationTokenCallCount = 0

  public func getNotificationToken() -> StoredNotificationToken? {
    self.getNotificationTokenCallCount += 1
    return self.storedNotificationToken
  }

  public private(set) var setNotificationTokenCallCount = 0

  public func setNotificationToken(token: StoredNotificationToken) {
    self.setNotificationTokenCallCount += 1
    self.storedNotificationToken = token
  }
}
