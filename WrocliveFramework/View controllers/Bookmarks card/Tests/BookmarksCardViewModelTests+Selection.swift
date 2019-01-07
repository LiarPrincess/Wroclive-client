// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import RxSwift
import RxCocoa
import RxTest
@testable import WrocliveFramework

extension BookmarksCardViewModelTests {

  func test_selectingItem_dispatchesTrackingAction() {
    let bookmarkIndex = 1
    self.setBookmarks(self.testData)
    self.viewModel = BookmarksCardViewModel(self.store)

    let event = next(100, bookmarkIndex)
    self.simulateSelectionEvents(event)
    self.startScheduler()

    let expectedLines = self.testData[bookmarkIndex].lines
    XCTAssertEqual(self.dispatchedActions.count, 1)
    XCTAssertEqual(self.getTrackedLinesStartTrackingAction(at: 0), expectedLines)
  }
}
