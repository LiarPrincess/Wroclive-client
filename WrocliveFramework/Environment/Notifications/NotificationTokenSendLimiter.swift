// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

private let second = 1.0
private let minute = 60 * second
private let hour = 60 * minute

public struct StoredNotificationToken: Equatable, Codable {

  public let date: Date
  public let value: String

  public init(date: Date, value: String) {
    self.date = date
    self.value = value
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
/// It also handles the edge case when we did send the token but it got lost.
public protocol NotificationTokenSendLimiterType {
  func shouldSend(token: String) -> Bool
  func registerSend(token: String)
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

  public func shouldSend(token: String) -> Bool {
    // No token stored
    guard let storedToken = self.store.getNotificationToken() else {
      return true
    }

    let oldToken = storedToken.value
    let hasTokenChanged = token != oldToken

    if hasTokenChanged {
      return true
    }

    // We will ignore all of the nuances of the time zones.
    let storeDate = storedToken.date
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

  public func registerSend(token: String) {
    let now = self.getDate()
    let storedToken = StoredNotificationToken(date: now, value: token)
    self.store.setNotificationToken(token: storedToken)
  }
}
