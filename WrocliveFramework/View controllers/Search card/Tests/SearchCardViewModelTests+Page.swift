// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import RxSwift
import RxCocoa
import RxTest
@testable import WrocliveFramework

extension SearchCardViewModelTests {

  func test_takesPagesState_fromStore() {
    let page0 = LineType.tram
    let page1 = LineType.bus
    let page2 = LineType.bus // we should skip this one as it is the same as previous
    let page3 = LineType.tram

    self.setState(SearchCardState(page: page0, selectedLines: []))
    self.scheduler.scheduleAt(100) { self.setState(SearchCardState(page: page1, selectedLines: [])) }
    self.scheduler.scheduleAt(200) { self.setState(SearchCardState(page: page2, selectedLines: [])) }
    self.scheduler.scheduleAt(300) { self.setState(SearchCardState(page: page3, selectedLines: [])) }

    self.initViewModel()
    self.startScheduler()

    XCTAssertEqual(self.pageObserver.events, [
      Recorded.next(0,   page0),
      Recorded.next(100, page1),
      Recorded.next(300, page3)
    ])

    XCTAssertEqual(self.storageMock.getSearchCardStateCount, 0) // we should get them from store
    XCTAssertEqual(self.storageMock.saveSearchCardStateCount, 0)
  }

  func test_changingPage_dispatchesSelectPageAction() {
    let initalState = SearchCardState(page: .bus, selectedLines: [])
    self.setState(initalState)

    self.initViewModel()
    self.mockPageSelected(at: 100, .tram)
    self.mockPageTransition(at: 200, .bus)
    self.mockPageTransition(at: 300, .bus)
    self.mockPageTransition(at: 400, .tram)

    self.startScheduler()

    XCTAssertEqual(self.dispatchedActions.count, 4)
    XCTAssertEqual(self.getSearchCardStateSelectPageAction(at: 0), LineType.tram)
    XCTAssertEqual(self.getSearchCardStateSelectPageAction(at: 1), LineType.bus)
    XCTAssertEqual(self.getSearchCardStateSelectPageAction(at: 2), LineType.bus)
    XCTAssertEqual(self.getSearchCardStateSelectPageAction(at: 3), LineType.tram)

    XCTAssertEqual(self.storageMock.getSearchCardStateCount, 0) // we should get them from store
    XCTAssertEqual(self.storageMock.saveSearchCardStateCount, 0)
  }
}
