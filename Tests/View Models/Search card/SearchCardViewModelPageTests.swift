//
//  Created by Michal Matuszczyk
//  Copyright © 2018 Michal Matuszczyk. All rights reserved.
//

import XCTest
import Result
import RxSwift
import RxCocoa
import RxTest
@testable import Wroclive

class SearchCardViewModelPageTests: SearchCardViewModelTestsBase {

  func test_startsWithPage_fromManager() {
    self.storageManager._searchCardState = SearchCardState(page: .tram, selectedLines: [])
    self.viewModel = SearchCardViewModel()

    let observer = self.testScheduler.createObserver(LineType.self)
    self.viewModel.page
      .drive(observer)
      .disposed(by: self.disposeBag)
    self.testScheduler.start()

    XCTAssertEqual(observer.events, [next(0, LineType.tram)])
    XCTAssertOperationCount(self.storageManager, getSearchCardState: 1, saveSearchCardState: 0)
  }

  func test_changingPage_updatesPage() {
    let initialPage = LineType.bus
    self.storageManager._searchCardState = SearchCardState(page: initialPage, selectedLines: [])
    self.viewModel = SearchCardViewModel()

    let line0 = next( 50, LineType.bus)
    let line2 = next(150, LineType.tram)
    self.simulatePageSelectedEvents(line0, line2)

    let line1 = next(100, LineType.tram)
    let line3 = next(200, LineType.bus)
    self.simulatePageDidTransitionEvents(line1, line3)

    let observer = self.testScheduler.createObserver(LineType.self)
    self.viewModel.page
      .drive(observer)
      .disposed(by: self.disposeBag)
    self.testScheduler.start()

    let expectedEvents = [next(0, initialPage), line0, line1, line2, line3]
    XCTAssertEqual(observer.events, expectedEvents)
  }
}
