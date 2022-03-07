// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import ReSwift
import Foundation
import WrocliveTestsShared
@testable import WrocliveFramework

extension NotificationsCardViewModelTests {

  // MARK: - Response

  func test_response_withNotifications_showsTable() {
    let viewModel = self.createViewModel()

    // Start state updates
    self.loadView(viewModel: viewModel)
    self.assertLoadingViewAfterViewDidLoad(viewModel: viewModel)

    let notifications = self.notifications
    self.setResponseState(.data(notifications))
    XCTAssertEqual(self.dispatchedActions.count, 1)
    XCTAssertEqual(self.refreshCount, 2)
    XCTAssertNil(self.apiErrorAlert)
    XCTAssertTrue(viewModel.isTableViewVisible)
    XCTAssertFalse(viewModel.isNoNotificationsViewVisible)
    XCTAssertFalse(viewModel.isLoadingViewVisible)
    self.assertCells(viewModel: viewModel, expected: notifications)
  }

  // MARK: - Empty response

  func test_response_withoutNotifications_showsNoNotificationsView() {
    let viewModel = self.createViewModel()

    // Start state updates
    self.loadView(viewModel: viewModel)
    self.assertLoadingViewAfterViewDidLoad(viewModel: viewModel)

    self.setResponseState(.data([]))
    XCTAssertEqual(self.dispatchedActions.count, 1)
    XCTAssertEqual(self.refreshCount, 2)
    XCTAssertNil(self.apiErrorAlert)
    XCTAssertFalse(viewModel.isTableViewVisible)
    XCTAssertTrue(viewModel.isNoNotificationsViewVisible)
    XCTAssertFalse(viewModel.isLoadingViewVisible)
    self.assertCells(viewModel: viewModel, expected: [])
  }

  // MARK: - Error

  func test_response_withError_showsApiError_then_tryAgain_getsNotifications() {
    let viewModel = self.createViewModel()

    // Start state updates
    self.loadView(viewModel: viewModel)
    self.assertLoadingViewAfterViewDidLoad(viewModel: viewModel)

    // Response with error
    let error = ApiError.invalidResponse
    self.setResponseState(.error(error))
    XCTAssertEqual(self.dispatchedActions.count, 1)
    XCTAssertEqual(self.refreshCount, 1)
    XCTAssertEqual(self.apiErrorAlert, error) // <- This
    XCTAssertFalse(viewModel.isTableViewVisible)
    XCTAssertFalse(viewModel.isNoNotificationsViewVisible)
    XCTAssertTrue(viewModel.isLoadingViewVisible)
    self.assertCells(viewModel: viewModel, expected: [])

    // Tap 'try again'
    self.apiErrorAlert = nil
    viewModel.viewDidPressAlertTryAgainButton()
    XCTAssertTrue(self.isRequestNotificationsAction(at: 1))

    XCTAssertEqual(self.dispatchedActions.count, 2)
    XCTAssertEqual(self.refreshCount, 1)
    XCTAssertNil(self.apiErrorAlert)
    XCTAssertFalse(viewModel.isTableViewVisible)
    XCTAssertFalse(viewModel.isNoNotificationsViewVisible)
    XCTAssertTrue(viewModel.isLoadingViewVisible)
    self.assertCells(viewModel: viewModel, expected: [])
  }
}
