// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import RxSwift
import RxCocoa
import RxTest
@testable import Wroclive

extension SearchCardViewModelTests {

  func test_startsWithSelectedLines_fromManager() {
    let lines = self.testData
    let state = SearchCardState(page: .tram, selectedLines: lines)
    self.storageManager.mockSearchCardState(state)

    self.initViewModel()
    self.startScheduler()

    XCTAssertEqual(self.selectedLinesObserver.events, [Recorded.next(0, lines)])
    self.storageManager.assertSearchCardStateOperationCount(get: 1, save: 0)
  }

  func test_selectingLine_updatesSelectedLines() {
    let lines = self.testData
    let state = SearchCardState(page: .tram, selectedLines: lines)
    let line0 = Line(name: "Test0", type: .tram, subtype: .regular)
    let line1 = Line(name: "Test1", type: .bus,  subtype: .express)

    self.storageManager.mockSearchCardState(state)
    self.initViewModel()

    self.mockSelectedLine(at: 100, line0)
    self.mockSelectedLine(at: 200, line1)

    self.startScheduler()

    XCTAssertEqual(self.selectedLinesObserver.events, [
      Recorded.next(0, lines),
      Recorded.next(100, lines + [line0]),
      Recorded.next(200, lines + [line0, line1])
    ])

    self.storageManager.assertSearchCardStateOperationCount(get: 1, save: 0)
  }

  func test_deselectingLine_updatesSelectedLines() {
    let lines = self.testData
    let state = SearchCardState(page: .tram, selectedLines: lines)
    let line0 = lines[0]
    let line1 = lines[2]

    self.storageManager.mockSearchCardState(state)
    self.initViewModel()

    self.mockDeselectedLine(at: 100, line0)
    self.mockDeselectedLine(at: 200, line1)

    self.startScheduler()

    XCTAssertEqual(self.selectedLinesObserver.events, [
      Recorded.next(0, lines),
      Recorded.next(100, [lines[1], lines[2], lines[3], lines[4]]),
      Recorded.next(200, [lines[1], lines[3], lines[4]])
    ])

    self.storageManager.assertSearchCardStateOperationCount(get: 1, save: 0)
  }
}
