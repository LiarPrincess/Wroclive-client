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
    let initialLines = self.testData
    let initialState = SearchCardState(page: .tram, selectedLines: initialLines)

    let page = LineType.bus
    let line0 = Line(name: "Test0", type: .tram, subtype: .regular)
    let line1 = Line(name: "Test1", type: .bus,  subtype: .express)

    self.storageManager.mockSearchCardState(initialState)
    self.initViewModel()

    self.mockPageSelected(at: 100, page)
    self.mockSelectedLine(at: 200, line0)
    self.mockSelectedLine(at: 300, line1)

    self.mockViewDidDisappear(at: 400)
    self.startScheduler()

    let newState = SearchCardState(page: page, selectedLines: initialLines + [line0, line1])
    self.storageManager.assertSearchCardStateOperation(newState)
    self.storageManager.assertSearchCardStateOperationCount(get: 1, save: 1)
  }
}
