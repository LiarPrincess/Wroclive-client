// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import WrocliveFramework

extension SearchCardViewModelTests {

  func test_bookmarkButton_noSelectedLines_showsNoLineSelectedAlert() {
    let lines = self.lines
    let selectedLines = [Line]()

    let state = SearchCardState(page: .tram, selectedLines: selectedLines)
    let response = LineResponse.data(lines)
    let viewModel = self.createViewModel(state: state, response: response)
    XCTAssertFalse(self.isShowingBookmarkNoLineSelectedAlert)

    viewModel.viewDidPressBookmarkButton()
    XCTAssertFalse(self.isShowingBookmarkNameInputAlert)
    XCTAssertTrue(self.isShowingBookmarkNoLineSelectedAlert)
    XCTAssertNil(self.apiErrorAlert)
    XCTAssertFalse(self.isClosing)
  }

  func test_bookmarkButton_withSelectedLines_startsBookmarkFlow() {
    let lines = self.lines
    let selectedLines = self.selectedLines

    let state = SearchCardState(page: .tram, selectedLines: selectedLines)
    let response = LineResponse.data(lines)
    let viewModel = self.createViewModel(state: state, response: response)
    XCTAssertEqual(self.refreshCount, 0)
    XCTAssertFalse(self.isShowingBookmarkNoLineSelectedAlert)
    XCTAssertFalse(self.isShowingBookmarkNoLineSelectedAlert)

    viewModel.viewDidPressBookmarkButton()
    XCTAssertTrue(self.isShowingBookmarkNameInputAlert)
    XCTAssertFalse(self.isShowingBookmarkNoLineSelectedAlert)
    XCTAssertNil(self.apiErrorAlert)
    XCTAssertFalse(self.isClosing)
    self.isShowingBookmarkNameInputAlert = false // Reset

    let name = "NAME"
    viewModel.viewDidEnterBookmarkName(value: name)
    XCTAssertFalse(self.isShowingBookmarkNameInputAlert)
    XCTAssertFalse(self.isShowingBookmarkNoLineSelectedAlert)
    XCTAssertNil(self.apiErrorAlert)
    XCTAssertFalse(self.isClosing)

    XCTAssertEqual(self.dispatchedActions.count, 1)
    if let (bName, bLines) = self.getAddBookmarkAction(at: 0) {
      XCTAssertEqual(bName, name)
      XCTAssertEqual(bLines, selectedLines)
    }

    // We should dispatch action (without modifying storage ourselves)
    XCTAssertEqual(self.storageManager.readBookmarksCount, 0)
    XCTAssertEqual(self.storageManager.writeBookmarksCount, 0)
  }
}
