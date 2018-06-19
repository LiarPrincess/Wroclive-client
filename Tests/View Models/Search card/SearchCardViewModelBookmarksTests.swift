//
//  Created by Michal Matuszczyk
//  Copyright © 2018 Michal Matuszczyk. All rights reserved.
//

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

    let observer = self.testScheduler.createObserver(SearchCardAlert.self)
    self.viewModel.showAlert
      .drive(observer)
      .disposed(by: self.disposeBag)
    self.testScheduler.start()

    XCTAssertEqual(observer.events, [next(100, SearchCardAlert.bookmarkNoLineSelected)])
  }

  func test_bookmarkButton_withSelectedLines_showsNameAlert() {
    self.storageManager._searchCardState = SearchCardState(page: .tram, selectedLines: self.testLines)
    self.viewModel = SearchCardViewModel()

    self.simulateBookmarkButtonPressedEvents(at: 100)

    let observer = self.testScheduler.createObserver(SearchCardAlert.self)
    self.viewModel.showAlert
      .drive(observer)
      .disposed(by: self.disposeBag)
    self.testScheduler.start()

    XCTAssertEqual(observer.events, [next(100, SearchCardAlert.bookmarkNameInput)])
  }

  func test_enteringName_createsBookmark() {
    self.storageManager._bookmarks       = []
    self.storageManager._searchCardState = SearchCardState(page: .tram, selectedLines: self.testLines)
    self.viewModel = SearchCardViewModel()

    let bookmark = Bookmark(name: "Test", lines: self.testLines)
    self.simulateBookmarkAlertNameEnteredEvents(next(100, bookmark.name))
    self.testScheduler.start()

    XCTAssertEqual(self.storageManager._bookmarks, [bookmark])
    XCTAssertOperationCount(self.storageManager, getBookmarks: 1, saveBookmarks: 1)
  }
}
