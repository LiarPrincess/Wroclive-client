// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import PromiseKit
@testable import WrocliveFramework

public final class ApiMock: ApiType {

  public init() {}

  // MARK: - Lines

  public var lines = [Line]()
  public private(set) var getLinesCallCount = 0

  public func getLines() -> Promise<[Line]> {
    self.getLinesCallCount += 1
    return .value(self.lines)
  }

  // MARK: - Vehicle locations

  public var vehicleLocations = [Vehicle]()
  public private(set) var getVehicleLocationsCallCount = 0

  public func getVehicleLocations(for lines: [Line]) -> Promise<[Vehicle]> {
    self.getVehicleLocationsCallCount += 1
    return .value(self.vehicleLocations)
  }

  // MARK: - Notification token

  public struct SendNotificationTokenArg {
    public let deviceId: UUID
    public let token: String
  }

  public private(set) var sendNotificationTokenCallCount = 0
  public private(set) var sendNotificationTokenArg: SendNotificationTokenArg?

  public func sendNotificationToken(deviceId: UUID, token: String) -> Promise<()> {
    self.sendNotificationTokenCallCount += 1
    self.sendNotificationTokenArg = SendNotificationTokenArg(deviceId: deviceId, token: token)
    return Promise.value()
  }

  // MARK: - Network activity indicator visibility

  public private(set) var setNetworkActivityIndicatorVisibilityCallCount = 0

  public func setNetworkActivityIndicatorVisibility(isVisible: Bool) {
    self.setNetworkActivityIndicatorVisibilityCallCount += 1
  }
}
