// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import RxSwift
import RxCocoa
import RxTest
@testable import Wroclive

class SearchCardViewModelSaveStateTests: SearchCardViewModelTestsBase {

  func test_didDisappear_savesState() {
    self.storageManager._searchCardState = SearchCardState(page: .tram, selectedLines: [])
    self.viewModel = SearchCardViewModel()

    let page = LineType.bus
    let line0 = Line(name: "Test0", type: .bus,  subtype: .express)
    let line1 = Line(name: "Test1", type: .tram, subtype: .regular)

    self.simulatePageSelectedEvents(next(100, page))
    self.simulateLineSelectedEvents(next(200, line0))
    self.simulateLineSelectedEvents(next(300, line1))

    self.simulateViewDidDisappearEvents(at: 400)
    self.startScheduler()

    let state = self.storageManager._searchCardState
    XCTAssertEqual(state, SearchCardState(page: page, selectedLines: [line0, line1]))
    XCTAssertOperationCount(self.storageManager, getSearchCardState: 1, saveSearchCardState: 1)
  }
}
