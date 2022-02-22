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
                                       NotificationsCardViewType,
                                       NotificationsCardViewModelDelegate {

  typealias WrocliveNotification = WrocliveFramework.Notification

  var store: Store<AppState>!
  var dispatchedActions: [Action]!
  var environment: Environment!

  var refreshCount = 0
  var apiErrorAlert: ApiError?
  var showDetailsNotification: WrocliveNotification?
  let now = Date(iso8601: "2022-01-01T00:00:00.000Z")!

  override func setUp() {
    super.setUp()
    self.setUpRedux()
    self.setUpEnvironment()
    self.refreshCount = 0
    self.apiErrorAlert = nil
    self.showDetailsNotification = nil
  }

  // MARK: - View model

  func refresh() {
    self.refreshCount += 1
  }

  func showApiErrorAlert(error: ApiError) {
    self.apiErrorAlert = error
  }

  func showDetails(notification: WrocliveNotification) {
    self.showDetailsNotification = notification
  }

  func createViewModel() -> NotificationsCardViewModel {
    let result = NotificationsCardViewModel(store: self.store,
                                            delegate: self,
                                            date: self.now)
    result.setView(view: self)
    self.refreshCount = 0
    return result
  }

  func loadView(viewModel: NotificationsCardViewModel,
                file: StaticString = #file,
                line: UInt = #line) {
    // This is how the store would react to 'ApiMiddlewareActions.requestNotifications'
    self.setResponseState(.inProgress)
    viewModel.viewDidLoad()
  }

  // MARK: - Data

  lazy var notifications: [WrocliveNotification] = [
    self.createNotification(suffix: "1"),
    self.createNotification(suffix: "2"),
    self.createNotification(suffix: "3"),
    self.createNotification(suffix: "4")
  ]

  private func createNotification(suffix: String) -> WrocliveNotification {
    return WrocliveNotification(id: "ID" + suffix,
                                url: "URL" + suffix,
                                authorName: "AUTHOR_NAME" + suffix,
                                authorUsername: "AUTHOR_USERNAME" + suffix,
                                date: self.now,
                                body: "BODY" + suffix)
  }

  // MARK: - State

  typealias Response = AppState.ApiResponseState<[WrocliveNotification]>

  func setResponseState(_ response: Response) {
    self.setState { $0.getNotificationsResponse = response }
  }

  // MARK: - Assert

  func assertLoadingViewAfterViewDidLoad(viewModel: NotificationsCardViewModel,
                                         file: StaticString = #file,
                                         line: UInt = #line) {
    XCTAssertEqual(self.dispatchedActions.count,
                   1,
                   "Dispatched actions count",
                   file: file,
                   line: line)

    XCTAssertTrue(self.isRequestNotificationsAction(at: 0),
                  "Expected to dispatch RequestNotificationsAction",
                  file: file,
                  line: line)

    XCTAssertFalse(viewModel.isTableViewVisible,
                   "isTableViewVisible",
                   file: file,
                   line: line)
    XCTAssertFalse(viewModel.isNoNotificationsViewVisible,
                   "isNoNotificationsViewVisible",
                   file: file,
                   line: line)
    XCTAssertTrue(viewModel.isLoadingViewVisible,
                  "isLoadingViewVisible",
                  file: file,
                  line: line)

    XCTAssertEqual(self.refreshCount, 1, "Refresh count", file: file, line: line)
    XCTAssertNil(self.apiErrorAlert, "Expected no alert", file: file, line: line)
    self.assertCells(viewModel: viewModel, expected: [], file: file, line: line)
  }

  func assertCells(viewModel: NotificationsCardViewModel,
                   expected: [WrocliveFramework.Notification],
                   file: StaticString = #file,
                   line: UInt = #line) {
    let cells = viewModel.cells

    XCTAssertEqual(cells.count,
                   expected.count,
                   "Notification count",
                   file: file,
                   line: line)

    for (index, (cell, notification)) in zip(cells, expected).enumerated() {
      XCTAssertEqual(cell.notification,
                     notification,
                     "Notification at \(index)",
                     file: file,
                     line: line)
    }
  }
}
