// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import WrocliveFramework

extension SearchCardViewModelTests {

  func test_pressingSearch_noSelectedLines_dispatchesTrackingAction_andCloses() {
    let lines = self.lines
    let selectedLines = [Line]()

    let state = SearchCardState(page: .tram, selectedLines: selectedLines)
    let response = LineResponse.data(lines)
    let viewModel = self.createViewModel(state: state, response: response)
    XCTAssertEqual(self.refreshCount, 0)
    XCTAssertFalse(self.isClosing)

    viewModel.viewDidPressSearchButton()
    XCTAssertFalse(self.isShowingBookmarkNameInputAlert)
    XCTAssertFalse(self.isShowingBookmarkNoLineSelectedAlert)
    XCTAssertNil(self.apiErrorAlert)
//    XCTAssertEqual(self.refreshCount, 1) // Not a part of the contract
    XCTAssertTrue(self.isClosing)

    XCTAssertEqual(self.dispatchedActions.count, 1)
    if let l = self.getStartTrackingLinesAction(at: 0) {
      XCTAssertEqual(l, selectedLines)
    }
  }

  func test_pressingSearch_withSelectedLines_dispatchesTrackingAction_andCloses() {
    let lines = self.lines
    let selectedLines = self.selectedLines
    assert(selectedLines.any)

    let state = SearchCardState(page: .tram, selectedLines: selectedLines)
    let response = LineResponse.data(lines)
    let viewModel = self.createViewModel(state: state, response: response)
    XCTAssertEqual(self.refreshCount, 0)
    XCTAssertFalse(self.isClosing)

    viewModel.viewDidPressSearchButton()
    XCTAssertFalse(self.isShowingBookmarkNameInputAlert)
    XCTAssertFalse(self.isShowingBookmarkNoLineSelectedAlert)
    XCTAssertNil(self.apiErrorAlert)
//    XCTAssertEqual(self.refreshCount, 1) // Not a part of the contract
    XCTAssertTrue(self.isClosing)

    XCTAssertEqual(self.dispatchedActions.count, 1)
    if let l = self.getStartTrackingLinesAction(at: 0) {
      XCTAssertEqual(l, selectedLines)
    }
  }
}
