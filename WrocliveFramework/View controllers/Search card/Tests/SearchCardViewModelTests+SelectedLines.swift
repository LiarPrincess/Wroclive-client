// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import RxSwift
import RxCocoa
import RxTest
@testable import WrocliveFramework

extension SearchCardViewModelTests {

  func test_takesSelectedLines_fromStore() {
    let lines0 = self.testLines
    let lines1 = self.testLines // we should skip this one as it is the same as previous
    let lines2 = [Line]()
    let lines3 = [self.testLines[0], self.testLines[1]]

    self.setState(SearchCardState(page: .tram, selectedLines: lines0))
    self.scheduler.scheduleAt(100) { self.setState(SearchCardState(page: .tram, selectedLines: lines1)) }
    self.scheduler.scheduleAt(200) { self.setState(SearchCardState(page: .tram, selectedLines: lines2)) }
    self.scheduler.scheduleAt(300) { self.setState(SearchCardState(page: .tram, selectedLines: lines3)) }

    self.initViewModel()
    self.startScheduler()

    XCTAssertEqual(self.selectedLinesObserver.events, [
      Recorded.next(0,   lines0),
      Recorded.next(200, lines2),
      Recorded.next(300, lines3)
    ])

    XCTAssertEqual(self.storageMock.getSearchCardStateCount, 0) // we should get them from store
    XCTAssertEqual(self.storageMock.saveSearchCardStateCount, 0)
  }

  func test_selectingLine_dispatchesSelectLineAction() {
    let line0 = Line(name: "Test0", type: .tram, subtype: .regular)
    let line1 = Line(name: "Test1", type: .bus,  subtype: .express)

    self.setState(SearchCardState(page: .tram, selectedLines: self.testLines))

    self.initViewModel()
    self.mockSelectedLine(at: 100, line0)
    self.mockSelectedLine(at: 200, line1)
    self.startScheduler()

    XCTAssertEqual(self.dispatchedActions.count, 2)
    XCTAssertEqual(self.getSearchCardStateSelectLineAction(at: 0), line0)
    XCTAssertEqual(self.getSearchCardStateSelectLineAction(at: 1), line1)

    XCTAssertEqual(self.storageMock.getSearchCardStateCount, 0) // we should get them from store
    XCTAssertEqual(self.storageMock.saveSearchCardStateCount, 0)
  }

  func test_deselectingLine_updatesSelectedLines() {
    let lines = self.testLines
    let line0 = lines[0]
    let line1 = lines[2]

    self.setState(SearchCardState(page: .tram, selectedLines: lines))

    self.initViewModel()
    self.mockDeselectedLine(at: 100, line0)
    self.mockDeselectedLine(at: 200, line1)
    self.startScheduler()

    XCTAssertEqual(self.dispatchedActions.count, 2)
    XCTAssertEqual(self.getSearchCardStateDeselectLineAction(at: 0), line0)
    XCTAssertEqual(self.getSearchCardStateDeselectLineAction(at: 1), line1)

    XCTAssertEqual(self.storageMock.getSearchCardStateCount, 0) // we should get them from store
    XCTAssertEqual(self.storageMock.saveSearchCardStateCount, 0)
  }
}
