// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import RxSwift
import RxCocoa
import RxTest
@testable import WrocliveFramework

extension SearchCardViewModelTests {

  func test_pressingSearch_dispatchesTrackingAction() {
    let state = SearchCardState(page: .tram, selectedLines: self.testLines)
    self.setState(state)

    self.initViewModel()
    self.mockSearchButtonPressed(at: 100)
    self.startScheduler()

    XCTAssertEqual(self.dispatchedActions.count, 1)
    XCTAssertEqual(self.getTrackedLinesStartTrackingAction(at: 0), state.selectedLines)
  }
}
