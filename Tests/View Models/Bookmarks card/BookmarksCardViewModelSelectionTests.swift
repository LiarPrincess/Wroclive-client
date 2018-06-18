//
//  Created by Michal Matuszczyk
//  Copyright © 2018 Michal Matuszczyk. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
@testable import Wroclive

class BookmarksCardViewModelSelectionTests: BookmarksCardViewModelTestsBase {
  func test_selectingItem_startsTracking() {
    let bookmarks = self.testData
    self.storageManager._bookmarks = bookmarks
    self.viewModel = BookmarksCardViewModel()

    let event = next(100, 1)
    self.simulateSelectionEvents(event)

    let observer = self.testScheduler.createObserver(Bookmark.self)
    viewModel.startTracking
      .drive(observer)
      .disposed(by: self.disposeBag)
    self.testScheduler.start()

    let expectedEvents = [next(100, bookmarks[1])]
    XCTAssertEqual(observer.events, expectedEvents)
  }
}
