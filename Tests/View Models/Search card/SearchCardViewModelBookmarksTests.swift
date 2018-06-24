// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import Result
import RxSwift
import RxCocoa
import RxTest
@testable import Wroclive

class SearchCardViewModelBookmarksTests: SearchCardViewModelTestsBase {

  func test_bookmarkButton_withoutSelectedLines_showsNoLineSelectedAlert() {
    self.storageManager._searchCardState = SearchCardState(page: .tram, selectedLines: [])
    self.viewModel = SearchCardViewModel()

    self.simulateBookmarkButtonPressedEvents(at: 100)

    let observer = self.scheduler.createObserver(SearchCardAlert.self)
    self.viewModel.showAlert
      .drive(observer)
      .disposed(by: self.disposeBag)
    self.startScheduler()

    XCTAssertEqual(observer.events, [next(100, SearchCardAlert.bookmarkNoLineSelected)])
  }

  func test_bookmarkButton_withSelectedLines_showsNameAlert() {
    self.storageManager._searchCardState = SearchCardState(page: .tram, selectedLines: self.testLines)
    self.viewModel = SearchCardViewModel()

    self.simulateBookmarkButtonPressedEvents(at: 100)

    let observer = self.scheduler.createObserver(SearchCardAlert.self)
    self.viewModel.showAlert
      .drive(observer)
      .disposed(by: self.disposeBag)
    self.startScheduler()

    XCTAssertEqual(observer.events, [next(100, SearchCardAlert.bookmarkNameInput)])
  }

  func test_enteringName_createsBookmark() {
    self.storageManager._bookmarks       = []
    self.storageManager._searchCardState = SearchCardState(page: .tram, selectedLines: self.testLines)
    self.viewModel = SearchCardViewModel()

    let bookmark = Bookmark(name: "Test", lines: self.testLines)
    self.simulateBookmarkAlertNameEnteredEvents(next(100, bookmark.name))
    self.startScheduler()

    XCTAssertEqual(self.storageManager._bookmarks, [bookmark])
    XCTAssertOperationCount(self.storageManager, getBookmarks: 1, saveBookmarks: 1)
  }
}
