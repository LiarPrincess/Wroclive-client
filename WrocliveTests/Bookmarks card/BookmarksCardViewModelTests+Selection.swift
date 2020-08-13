// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import WrocliveFramework

extension BookmarksCardViewModelTests {

  func test_selectingItem_dispatchesTrackingAction() {
    self.setBookmarks(self.testData)
    let viewModel = self.createViewModel()

    let index = 1
    viewModel.viewDidSelectItem(index: index)

    if let lines = self.getStartTrackingLinesAction(at: 0) {
      let expectedLines = self.testData[index].lines
      XCTAssertEqual(lines, expectedLines)
    }
  }

  func test_selectingItem_closesView() {
    self.setBookmarks(self.testData)
    let viewModel = self.createViewModel()

    let index = 1
    viewModel.viewDidSelectItem(index: index)
    XCTAssertEqual(self.closeCallCount, 1)
  }
}
