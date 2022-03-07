// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import PromiseKit

public protocol ApiType {

  /// Get all currently available mpk lines.
  func getLines() -> Promise<[Line]>

  /// Get current vehicle locations for selected lines.
  func getVehicleLocations(for lines: [Line]) -> Promise<[Vehicle]>

  /// Get list of current alerts and stuff.
  func getNotifications() -> Promise<[Notification]>

  /// Send token, so that our server can send push notifications to this device.
  func sendNotificationToken(deviceId: UUID, token: String) -> Promise<Void>

  /// Show/hide network activity indicator (little circle in the upper left corner).
  func setNetworkActivityIndicatorVisibility(isVisible: Bool)
}
