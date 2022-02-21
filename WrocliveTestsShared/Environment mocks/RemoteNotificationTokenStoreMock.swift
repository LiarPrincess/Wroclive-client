// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import WrocliveFramework

public final class RemoteNotificationTokenStoreMock: RemoteNotificationTokenStore {

  public init() {}

  public var storedToken: StoredRemoteNotificationToken?
  public private(set) var getNotificationTokenCallCount = 0

  public func getRemoteNotificationToken() -> StoredRemoteNotificationToken? {
    self.getNotificationTokenCallCount += 1
    return self.storedToken
  }

  public private(set) var setNotificationTokenCallCount = 0

  public func setRemoteNotificationToken(token: StoredRemoteNotificationToken) {
    self.setNotificationTokenCallCount += 1
    self.storedToken = token
  }
}
