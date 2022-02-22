// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import ReSwift
import Foundation
import WrocliveTestsShared
@testable import WrocliveFramework

extension NotificationsCardViewModelTests {

  func test_tappingCell_showsDetails() {
    let viewModel = self.createViewModel()

    // Start state updates
    self.loadView(viewModel: viewModel)
    self.assertLoadingViewAfterViewDidLoad(viewModel: viewModel)

    // Response with notifications
    let notifications = self.notifications
    self.setResponseState(.data(notifications))
    XCTAssertEqual(self.dispatchedActions.count, 1)
    XCTAssertEqual(self.refreshCount, 2)
    XCTAssertNil(self.apiErrorAlert)
    XCTAssertTrue(viewModel.isTableViewVisible)
    XCTAssertFalse(viewModel.isNoNotificationsViewVisible)
    XCTAssertFalse(viewModel.isLoadingViewVisible)
    self.assertCells(viewModel: viewModel, expected: notifications)

    self.showDetailsNotification = nil
    viewModel.viewDidSelectItem(index: 0)
    XCTAssertEqual(self.showDetailsNotification, notifications[0])

    self.showDetailsNotification = nil
    viewModel.viewDidSelectItem(index: 2)
    XCTAssertEqual(self.showDetailsNotification, notifications[2])
  }
}
