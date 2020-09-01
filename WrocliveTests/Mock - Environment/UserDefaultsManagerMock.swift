// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
@testable import WrocliveFramework

class UserDefaultsManagerMock: UserDefaultsManagerType {

  // MARK: - Preferred map type

  private(set) var getPreferredMapTypeCount = 0
  private(set) var setPreferredMapTypeCount = 0

  var preferredMapType: MapType?

  func getPreferredMapType() -> MapType? {
    self.getPreferredMapTypeCount += 1
    return self.preferredMapType
  }

  func setPreferredMapType(mapType: MapType) {
    self.setPreferredMapTypeCount += 1
    self.preferredMapType = mapType
  }
}
