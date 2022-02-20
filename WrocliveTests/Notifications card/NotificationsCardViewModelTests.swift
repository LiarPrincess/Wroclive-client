// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import ReSwift
import Foundation
import WrocliveTestsShared
@testable import WrocliveFramework

// swiftlint:disable force_unwrapping
// swiftlint:disable implicitly_unwrapped_optional

class NotificationsCardViewModelTests: XCTestCase,
                                       ReduxTestCase,
                                       EnvironmentTestCase,
                                       NotificationsCardViewType {

  var store: Store<AppState>!
  var dispatchedActions: [Action]!
  var environment: Environment!

  var refreshCount = 0
  var apiErrorAlert: ApiError?
  let now = Date(iso8601: "2022-01-01T00:00:00.000Z")!

  override func setUp() {
    super.setUp()
    self.setUpRedux()
    self.setUpEnvironment()
    self.refreshCount = 0
    self.apiErrorAlert = nil
  }

  // MARK: - View model

  func refresh() {
    self.refreshCount += 1
  }

  func showApiErrorAlert(error: ApiError) {
    self.apiErrorAlert = error
  }

  func createViewModel() -> NotificationsCardViewModel {
    let result = NotificationsCardViewModel(store: self.store, date: now)
    result.setView(view: self)
    self.refreshCount = 0
    return result
  }

  // MARK: - Data

  lazy var notifications: [WrocliveFramework.Notification] = [
    self.createNotification(suffix: "1"),
    self.createNotification(suffix: "2"),
    self.createNotification(suffix: "3"),
    self.createNotification(suffix: "4")
  ]

  private func createNotification(suffix: String) -> WrocliveFramework.Notification {
    return WrocliveFramework.Notification(id: "ID" + suffix,
                                          url: "URL" + suffix,
                                          authorName: "AUTHOR_NAME" + suffix,
                                          authorUsername: "AUTHOR_USERNAME" + suffix,
                                          date: self.now,
                                          body: "BODY" + suffix)
  }

  // MARK: - State

  typealias Response = AppState.ApiResponseState<[WrocliveFramework.Notification]>

  func setResponseState(_ response: Response) {
    self.setState { $0.getNotificationsResponse = response }
  }
}
