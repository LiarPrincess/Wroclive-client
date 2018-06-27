// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import RxSwift
import RxCocoa
import RxTest
@testable import Wroclive

class SearchCardViewModelPageTests: SearchCardViewModelTestsBase {

  func test_opening_startsWithPage_fromSavedState() {
    let state = SearchCardState(page: .tram, selectedLines: [])
    self.storageManager.mockSearchCardState(state)

    self.initViewModel()
    self.startScheduler()

    XCTAssertEqual(self.pageObserver.events, [
      Recorded.next(0, state.page)
    ])

    self.storageManager.assertSearchCardStateOperationCount(get: 1, save: 0)
  }

  /**
   Steps:
   0 Bus
   100 Selector -> Tram
   200 Gesture -> Bus
   300 Gesture -> Bus
   400 Gesture -> Tram
   500 Selector -> Bus
   500 Selector -> Bus
   */
  func test_changingPage_updatesPage() {
    let state = SearchCardState(page: .tram, selectedLines: [])
    self.storageManager.mockSearchCardState(state)

    self.initViewModel()

    self.mockPageSelected(at: 100, .tram)
    self.mockPageTransition(at: 200, .bus)
    self.mockPageTransition(at: 300, .bus)
    self.mockPageTransition(at: 400, .tram)
    self.mockPageSelected(at: 500, .bus)
    self.mockPageSelected(at: 600, .bus)

    self.startScheduler()

    XCTAssertEqual(self.pageObserver.events, [
      Recorded.next(0, state.page),
      Recorded.next(100, LineType.tram),
      Recorded.next(200, LineType.bus),
      Recorded.next(300, LineType.bus),
      Recorded.next(400, LineType.tram),
      Recorded.next(500, LineType.bus),
      Recorded.next(600, LineType.bus)
    ])

    self.storageManager.assertSearchCardStateOperationCount(get: 1, save: 0)
  }
}
