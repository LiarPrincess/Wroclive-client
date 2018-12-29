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
//extension SearchCardViewModelTests {
//
//  func test_search_startsTracking() {
//    let lines = self.testData
//    let state = SearchCardState(page: .tram, selectedLines: lines)
//    self.storageManager.mockSearchCardState(state)
//
//    self.initViewModel()
//    self.mockSearchButtonPressed(at: 100)
//    self.startScheduler()
//
//    XCTAssertEqual(self.startTrackingObserver.events, [
//      Recorded.next(100, lines)
//    ])
//  }
//}
