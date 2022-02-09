// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import WrocliveTestsShared
@testable import WrocliveFramework

final class NotificationTokenStoreMock: NotificationTokenStore {

  var storedNotificationToken: StoredNotificationToken?
  var getNotificationTokenCount = 0
  var setNotificationTokenCount = 0

  func getNotificationToken() -> StoredNotificationToken? {
    self.getNotificationTokenCount += 1
    return self.storedNotificationToken
  }

  func setNotificationToken(token: StoredNotificationToken) {
    self.setNotificationTokenCount += 1
    self.storedNotificationToken = token
  }
}
