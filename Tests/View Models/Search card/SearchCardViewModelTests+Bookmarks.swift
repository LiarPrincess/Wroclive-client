// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import RxSwift
import RxCocoa
import RxTest
@testable import Wroclive

extension SearchCardViewModelTests {

  func test_bookmarkButton_withoutSelectedLines_showsNoLineSelectedAlert() {
    let state = SearchCardState(page: .tram, selectedLines: [])
    self.storageManager.mockSearchCardState(state)

    self.initViewModel()
    self.mockBookmarkButtonPressed(at: 100)
    self.startScheduler()

    XCTAssertEqual(self.showAlertObserver.events, [
      Recorded.next(100, SearchCardAlert.bookmarkNoLineSelected)
    ])
  }

  func test_bookmarkButton_withSelectedLines_showsNameAlert() {
    let lines = self.testData
    let state = SearchCardState(page: .tram, selectedLines: lines)
    self.storageManager.mockSearchCardState(state)

    self.initViewModel()
    self.mockBookmarkButtonPressed(at: 100)
    self.startScheduler()

    XCTAssertEqual(self.showAlertObserver.events, [
      Recorded.next(100, SearchCardAlert.bookmarkNameInput)
    ])
  }

  func test_enteringName_createsBookmark() {
    let lines = self.testData
    let state = SearchCardState(page: .tram, selectedLines: lines)
    let bookmark = Bookmark(name: "Test", lines: lines)

    self.storageManager.mockSearchCardState(state)
    self.initViewModel()
    self.mockBookmarkAlertNameEntered(at: 100, bookmark.name)
    self.startScheduler()

    self.storageManager.assertBookmarks([bookmark])
    self.storageManager.assertBookmarkOperationCount(get: 1, save: 1)
  }
}
