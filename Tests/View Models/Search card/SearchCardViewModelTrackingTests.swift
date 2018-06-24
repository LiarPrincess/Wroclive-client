// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import RxSwift
import RxCocoa
import RxTest
@testable import Wroclive

class SearchCardViewModelTrackingTests: SearchCardViewModelTestsBase {

  func test_search_startsTracking() {
    let lines = self.testLines
    self.storageManager._searchCardState = SearchCardState(page: .tram, selectedLines: lines)
    self.viewModel = SearchCardViewModel()

    self.simulateSearchButtonPressedEvents(at: 100)

    let observer = self.scheduler.createObserver([Line].self)
    self.viewModel.startTracking
      .drive(observer)
      .disposed(by: self.disposeBag)
    self.startScheduler()

    XCTAssertEqual(observer.events, [next(100, lines)])
  }
}
