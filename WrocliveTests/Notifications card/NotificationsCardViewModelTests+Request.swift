// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import ReSwift
import Foundation
import WrocliveTestsShared
@testable import WrocliveFramework

// swiftlint:disable function_body_length

private func XCTAssertCells(viewModel: NotificationsCardViewModel,
                            expected: [WrocliveFramework.Notification],
                            file: StaticString = #file,
                            line: UInt = #line) {
  let cells = viewModel.cells

  XCTAssertEqual(cells.count,
                 expected.count,
                 "Count",
                 file: file,
                 line: line)

  for (index, (cell, notification)) in zip(cells, expected).enumerated() {
    XCTAssertEqual(cell.notification,
                   notification,
                   "Notification - \(index)",
                   file: file,
                   line: line)
  }
}

extension NotificationsCardViewModelTests {

  // MARK: - Response

  func test_noneResponse_viewLoads_returnsNotifications_showsTable() {
    self.setState { $0.getNotificationsResponse = .none }
    let viewModel = self.createViewModel()
    XCTAssertEqual(self.dispatchedActions.count, 0)
    XCTAssertEqual(self.refreshCount, 0)
    XCTAssertNil(self.apiErrorAlert)
    XCTAssertFalse(viewModel.isTableViewVisible)
    XCTAssertFalse(viewModel.isNoNotificationsViewVisible)
    XCTAssertTrue(viewModel.isLoadingViewVisible)
    XCTAssertCells(viewModel: viewModel, expected: [])

    // viewDidLoad
    viewModel.viewDidLoad()
    XCTAssertTrue(self.isRequestNotificationsAction(at: 0))

    self.setResponseState(.inProgress)
    XCTAssertEqual(self.dispatchedActions.count, 1)
    XCTAssertEqual(self.refreshCount, 0)
    XCTAssertNil(self.apiErrorAlert)
    XCTAssertFalse(viewModel.isTableViewVisible)
    XCTAssertFalse(viewModel.isNoNotificationsViewVisible)
    XCTAssertTrue(viewModel.isLoadingViewVisible)
    XCTAssertCells(viewModel: viewModel, expected: [])

    // Response with notifications
    let notifications = self.notifications
    self.setResponseState(.data(notifications))
    XCTAssertEqual(self.dispatchedActions.count, 1)
    XCTAssertEqual(self.refreshCount, 1)
    XCTAssertNil(self.apiErrorAlert)
    XCTAssertTrue(viewModel.isTableViewVisible)
    XCTAssertFalse(viewModel.isNoNotificationsViewVisible)
    XCTAssertFalse(viewModel.isLoadingViewVisible)
    XCTAssertCells(viewModel: viewModel, expected: notifications)
  }

  // MARK: - Empty response

  func test_noneResponse_viewLoads_returnsNoNotifications_showsNoNotifications() {
    self.setState { $0.getNotificationsResponse = .none }
    let viewModel = self.createViewModel()
    XCTAssertEqual(self.dispatchedActions.count, 0)
    XCTAssertEqual(self.refreshCount, 0)
    XCTAssertNil(self.apiErrorAlert)
    XCTAssertFalse(viewModel.isTableViewVisible)
    XCTAssertFalse(viewModel.isNoNotificationsViewVisible)
    XCTAssertTrue(viewModel.isLoadingViewVisible)
    XCTAssertCells(viewModel: viewModel, expected: [])

    // viewDidLoad
    viewModel.viewDidLoad()
    XCTAssertTrue(self.isRequestNotificationsAction(at: 0))

    self.setResponseState(.inProgress)
    XCTAssertEqual(self.dispatchedActions.count, 1)
    XCTAssertEqual(self.refreshCount, 0)
    XCTAssertNil(self.apiErrorAlert)
    XCTAssertFalse(viewModel.isTableViewVisible)
    XCTAssertFalse(viewModel.isNoNotificationsViewVisible)
    XCTAssertTrue(viewModel.isLoadingViewVisible)
    XCTAssertCells(viewModel: viewModel, expected: [])

    // Response without notifications
    self.setResponseState(.data([]))
    XCTAssertEqual(self.dispatchedActions.count, 1)
    XCTAssertEqual(self.refreshCount, 1)
    XCTAssertNil(self.apiErrorAlert)
    XCTAssertFalse(viewModel.isTableViewVisible)
    XCTAssertTrue(viewModel.isNoNotificationsViewVisible)
    XCTAssertFalse(viewModel.isLoadingViewVisible)
    XCTAssertCells(viewModel: viewModel, expected: [])
  }

  // MARK: - Error

  func test_noneResponse_viewLoads_returnsError_showsApiError_tryAgain() {
    self.setState { $0.getNotificationsResponse = .none }
    let viewModel = self.createViewModel()
    XCTAssertEqual(self.dispatchedActions.count, 0)
    XCTAssertEqual(self.refreshCount, 0)
    XCTAssertNil(self.apiErrorAlert)
    XCTAssertFalse(viewModel.isTableViewVisible)
    XCTAssertFalse(viewModel.isNoNotificationsViewVisible)
    XCTAssertTrue(viewModel.isLoadingViewVisible)
    XCTAssertCells(viewModel: viewModel, expected: [])

    // viewDidLoad
    viewModel.viewDidLoad()
    XCTAssertTrue(self.isRequestNotificationsAction(at: 0))

    self.setResponseState(.inProgress)
    XCTAssertEqual(self.dispatchedActions.count, 1)
    XCTAssertEqual(self.refreshCount, 0)
    XCTAssertNil(self.apiErrorAlert)
    XCTAssertFalse(viewModel.isTableViewVisible)
    XCTAssertFalse(viewModel.isNoNotificationsViewVisible)
    XCTAssertTrue(viewModel.isLoadingViewVisible)
    XCTAssertCells(viewModel: viewModel, expected: [])

    // Response with error
    let error = ApiError.invalidResponse
    self.setResponseState(.error(error))
    XCTAssertEqual(self.dispatchedActions.count, 1)
    XCTAssertEqual(self.refreshCount, 0)
    XCTAssertEqual(self.apiErrorAlert, error)
    XCTAssertFalse(viewModel.isTableViewVisible)
    XCTAssertFalse(viewModel.isNoNotificationsViewVisible)
    XCTAssertTrue(viewModel.isLoadingViewVisible)
    XCTAssertCells(viewModel: viewModel, expected: [])

    // Tap 'try again'
    self.apiErrorAlert = nil
    viewModel.viewDidPressAlertTryAgainButton()
    XCTAssertTrue(self.isRequestNotificationsAction(at: 1))

    XCTAssertEqual(self.dispatchedActions.count, 2)
    XCTAssertEqual(self.refreshCount, 0)
    XCTAssertNil(self.apiErrorAlert)
    XCTAssertFalse(viewModel.isTableViewVisible)
    XCTAssertFalse(viewModel.isNoNotificationsViewVisible)
    XCTAssertTrue(viewModel.isLoadingViewVisible)
    XCTAssertCells(viewModel: viewModel, expected: [])
  }
}
