// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import RxSwift
import RxCocoa
import RxTest
@testable import WrocliveFramework

extension SearchCardViewModelTests {

  func test_bookmarkButton_withoutSelectedLines_showsNoLineSelectedAlert() {
    self.setState(SearchCardState(page: .tram, selectedLines: []))

    self.initViewModel()
    self.mockBookmarkButtonPressed(at: 100)
    self.startScheduler()

    XCTAssertEqual(self.showAlertObserver.events, [
      Recorded.next(100, SearchCardAlert.bookmarkNoLineSelected)
    ])
  }

  func test_bookmarkButton_withSelectedLines_showsNameAlert() {
    self.setState(SearchCardState(page: .tram, selectedLines: self.testLines))

    self.initViewModel()
    self.mockBookmarkButtonPressed(at: 100)
    self.startScheduler()

    XCTAssertEqual(self.showAlertObserver.events, [
      Recorded.next(100, SearchCardAlert.bookmarkNameInput)
    ])
  }

  func test_enteringName_dispatchesAddBookmarkAction() {
    let bookmark = Bookmark(name: "Test", lines: self.testLines)
    self.setState(SearchCardState(page: .tram, selectedLines: bookmark.lines))

    self.initViewModel()
    self.mockBookmarkAlertNameEntered(at: 100, bookmark.name)
    self.startScheduler()

    XCTAssertEqual(self.dispatchedActions.count, 1)

    let addBookmarkAction = self.getBookmarksAddAction(at: 0)
    XCTAssertEqual(addBookmarkAction?.0, bookmark.name)
    XCTAssertEqual(addBookmarkAction?.1, bookmark.lines)

    // we should just dispatch action
    XCTAssertEqual(self.storageMock.getBookmarksCount, 0)
    XCTAssertEqual(self.storageMock.saveBookmarksCount, 0)
  }
}
