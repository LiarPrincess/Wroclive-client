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
    let viewModel = self.createViewModel(state: state)

    viewModel.viewDidLoad()
    self.assertStateAfterViewDidLoad(viewModel: viewModel)
    self.setLineResponseState(.data(lines))

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
    let viewModel = self.createViewModel(state: state)

    viewModel.viewDidLoad()
    self.assertStateAfterViewDidLoad(viewModel: viewModel)
    self.setLineResponseState(.data(lines))

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

    XCTAssertEqual(self.dispatchedActions.count, 2)
    if let (bName, bLines) = self.getAddBookmarkAction(at: 1) {
      XCTAssertEqual(bName, name)
      XCTAssertEqual(bLines, selectedLines)
    }

    // We should dispatch action (without modifying storage ourselves)
    XCTAssertEqual(self.storageManager.readBookmarksCount, 0)
    XCTAssertEqual(self.storageManager.writeBookmarksCount, 0)
  }
}
