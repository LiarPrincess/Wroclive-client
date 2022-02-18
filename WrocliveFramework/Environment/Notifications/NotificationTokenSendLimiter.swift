// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

private let second = 1.0
private let minute = 60 * second
private let hour = 60 * minute

public struct StoredNotificationToken: Equatable, Codable {

  public let date: Date
  public let deviceId: UUID
  public let token: String

  public init(date: Date, deviceId: UUID, token: String) {
    self.date = date
    self.deviceId = deviceId
    self.token = token
  }
}

public protocol NotificationTokenStore {
  func getNotificationToken() -> StoredNotificationToken?
  func setNotificationToken(token: StoredNotificationToken)
}

// MARK: - Send limiter

/// We will send new token to server, but only once in a while.
/// We don't want to use too much battery when user opens/closes the app repeatedly.
///
/// Btw. It does handle the edge case when we did send the token but it got lost
/// by setting the send interval to relatively small value (not weeks/years etc.).
public protocol NotificationTokenSendLimiterType {
  func shouldSend(deviceId: UUID, token: String) -> Bool
  func registerSend(deviceId: UUID, token: String)
}

public final class NotificationTokenSendLimiter: NotificationTokenSendLimiterType {

  public typealias GetDate = () -> Date

  public static let sendInterval = 23 * hour

  private let store: NotificationTokenStore
  private let getDate: GetDate

  public init(store: NotificationTokenStore, getDate: GetDate? = nil) {
    self.store = store
    self.getDate = getDate ?? Date.init
  }

  public func shouldSend(deviceId: UUID, token: String) -> Bool {
    // No token stored -> send
    guard let stored = self.store.getNotificationToken() else {
      return true
    }

    // Changed? -> send
    let isEqual = deviceId == stored.deviceId && token == stored.token
    if !isEqual {
      return true
    }

    // We will ignore all of the nuances of the time zones.
    let storeDate = stored.date
    let storeDate1970 = storeDate.timeIntervalSince1970

    let now = self.getDate()
    let now1970 = now.timeIntervalSince1970

    // If we somehow stored the value in the future then we will assume app error.
    let isStoredInFuture = storeDate1970 >= now1970
    if isStoredInFuture {
      return true
    }

    let interval = now1970 - storeDate1970
    return interval >= NotificationTokenSendLimiter.sendInterval
  }

  public func registerSend(deviceId: UUID, token: String) {
    let now = self.getDate()
    let stored = StoredNotificationToken(date: now, deviceId: deviceId, token: token)
    self.store.setNotificationToken(token: stored)
  }
}
