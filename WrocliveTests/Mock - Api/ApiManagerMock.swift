// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import PromiseKit
@testable import WrocliveFramework

class ApiMock: ApiType {

  private(set) var getLinesCallCount = 0
  private(set) var getVehicleLocationsCallCount = 0
  private(set) var setNetworkActivityIndicatorVisibilityCallCount = 0

  // MARK: - Lines

  var lines = [Line]()

  func getLines() -> Promise<[Line]> {
    self.getLinesCallCount += 1
    return .value(self.lines)
  }

  // MARK: - Vehicle locations

  var vehicleLocations = [Vehicle]()

  func getVehicleLocations(for lines: [Line]) -> Promise<[Vehicle]> {
    self.getVehicleLocationsCallCount += 1
    return .value(self.vehicleLocations)
  }

  // MARK: - Network activity indicator visibility

  func setNetworkActivityIndicatorVisibility(isVisible: Bool) {
    self.setNetworkActivityIndicatorVisibilityCallCount += 1
  }
}
