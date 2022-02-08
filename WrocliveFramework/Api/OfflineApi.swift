// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import os.log
import PromiseKit

#if DEBUG

private let networkDelay = TimeInterval(1.0)

public final class OfflineApi: ApiType {

  // swiftlint:disable:next discouraged_optional_collection
  private var lastSendVehicles: [Vehicle]?
  private let logManager: LogManagerType

  private var log: OSLog {
    return self.logManager.api
  }

  public init(log: LogManagerType) {
    self.logManager = log
  }

  public func getLines() -> Promise<[Line]> {
    os_log("[offline] Sending 'getLines' request", log: self.log, type: .debug)

    return after(seconds: networkDelay)
      .then { _ in Promise.value(DummyData.lines) }
  }

  public func getVehicleLocations(for lines: [Line]) -> Promise<[Vehicle]> {
    if lines.isEmpty {
      os_log("No lines requested in 'getVehicleLocations'", log: self.log, type: .debug)
      return .value([])
    }

    os_log("[offline] Sending 'getVehicleLocations' request", log: self.log, type: .debug)

    let vehicles: [Vehicle]
    if let oldVehicles = self.lastSendVehicles {
      vehicles = oldVehicles.map { rotate(vehicle: $0, degrees: 30) }
    } else {
      vehicles = DummyData.vehicles
    }

    self.lastSendVehicles = vehicles
    return after(seconds: networkDelay)
      .then { _ in Promise.value(vehicles) }
  }

  public func sendNotificationToken(deviceId: UUID, token: String) -> Promise<()> {
    os_log("[offline] Sending 'notification-token' request", log: self.log, type: .debug)
    return Promise.value()
  }

  public func setNetworkActivityIndicatorVisibility(isVisible: Bool) {}
}

private func rotate(vehicle: Vehicle, degrees: Double) -> Vehicle {
  return Vehicle(id: vehicle.id,
                 line: vehicle.line,
                 latitude: vehicle.latitude,
                 longitude: vehicle.longitude,
                 angle: vehicle.angle + degrees)
}

#endif
