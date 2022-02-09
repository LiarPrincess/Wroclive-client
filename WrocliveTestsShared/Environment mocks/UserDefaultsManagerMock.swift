// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
@testable import WrocliveFramework

public class UserDefaultsManagerMock: UserDefaultsManagerType {

  // MARK: - Preferred map type

  public private(set) var getPreferredMapTypeCount = 0
  public private(set) var setPreferredMapTypeCount = 0

  public var preferredMapType: MapType?

  public func getPreferredMapType() -> MapType? {
    self.getPreferredMapTypeCount += 1
    return self.preferredMapType
  }

  public func setPreferredMapType(mapType: MapType) {
    self.setPreferredMapTypeCount += 1
    self.preferredMapType = mapType
  }

  // MARK: - Notification token

  public private(set) var getNotificationTokenCount = 0
  public private(set) var setNotificationTokenCount = 0

  public var notificationToken: StoredNotificationToken?

  public func getNotificationToken() -> StoredNotificationToken? {
    self.getNotificationTokenCount += 1
    return self.notificationToken
  }

  public func setNotificationToken(token: StoredNotificationToken) {
    self.setNotificationTokenCount += 1
    self.notificationToken = token
  }
}
