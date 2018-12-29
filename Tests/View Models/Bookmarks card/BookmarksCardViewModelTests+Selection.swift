//// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
//// If a copy of the MPL was not distributed with this file,
//// You can obtain one at http://mozilla.org/MPL/2.0/.
//
//import XCTest
//import RxSwift
//import RxCocoa
//import RxTest
//@testable import Wroclive
//
//extension BookmarksCardViewModelTests {
//
//  func test_selectingItem_startsTracking() {
//    let bookmarks = self.testData
//    self.storageManager._bookmarks = bookmarks
//    self.viewModel = BookmarksCardViewModel()
//
//    let event = next(100, 1)
//    self.simulateSelectionEvents(event)
//
//    let observer = self.scheduler.createObserver(Bookmark.self)
//    viewModel.startTracking
//      .drive(observer)
//      .disposed(by: self.disposeBag)
//    self.startScheduler()
//
//    let expectedEvents = [next(100, bookmarks[1])]
//    XCTAssertEqual(observer.events, expectedEvents)
//  }
//}
