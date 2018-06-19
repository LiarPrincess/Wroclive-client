//
//  Created by Michal Matuszczyk
//  Copyright © 2018 Michal Matuszczyk. All rights reserved.
//

import XCTest
import Result
import RxSwift
import RxCocoa
import RxTest
import RxBlocking
@testable import Wroclive

class SearchCardViewModelLineSelectionTests: SearchCardViewModelTestsBase {

  func test_startsWithSelectedLines_fromManager() {
    let lines = self.testLines
    self.storageManager._searchCardState = SearchCardState(page: .tram, selectedLines: lines)
    self.viewModel = SearchCardViewModel()

    let observer = self.testScheduler.createObserver([Line].self)
    self.viewModel.selectedLines
      .drive(observer)
      .disposed(by: self.disposeBag)
    self.testScheduler.start()

    XCTAssertEqual(observer.events, [next(0, lines)])
    XCTAssertOperationCount(self.storageManager, getSearchCardState: 1, saveSearchCardState: 0)
  }

  func test_selectingLine_updatesSelectedLines() {
    self.storageManager._searchCardState = SearchCardState(page: .tram, selectedLines: self.testLines)
    self.viewModel = SearchCardViewModel()

    let event0 = next(100, Line(name: "Test0", type: .tram, subtype: .regular))
    let event1 = next(200, Line(name: "Test1", type: .bus,  subtype: .express))
    self.simulateLineSelectedEvents(event0, event1)

    let observer = self.testScheduler.createObserver([Line].self)
    self.viewModel.selectedLines
      .drive(observer)
      .disposed(by: self.disposeBag)
    self.testScheduler.start()

    let expectedEvents = [
      next(  0, self.testLines),
      next(100, self.testLines + [event0.value.element!]),
      next(200, self.testLines + [event0.value.element!, event1.value.element!])]
    XCTAssertEqual(observer.events, expectedEvents)
    XCTAssertOperationCount(self.storageManager, getSearchCardState: 1, saveSearchCardState: 0)
  }

  func test_deselectingLine_updatesSelectedLines() {
    self.storageManager._searchCardState = SearchCardState(page: .tram, selectedLines: self.testLines)
    self.viewModel = SearchCardViewModel()

    let event0 = next(100, self.testLines[0])
    let event1 = next(200, self.testLines[2])
    self.simulateLineDeselectedEvents(event0, event1)

    let observer = self.testScheduler.createObserver([Line].self)
    self.viewModel.selectedLines
      .drive(observer)
      .disposed(by: self.disposeBag)
    self.testScheduler.start()

    let expectedEvents = [
      next(  0, self.testLines),
      next(100, [self.testLines[1], self.testLines[2], self.testLines[3], self.testLines[4]]),
      next(200, [self.testLines[1], self.testLines[3], self.testLines[4]])]
    XCTAssertEqual(observer.events, expectedEvents)
    XCTAssertOperationCount(self.storageManager, getSearchCardState: 1, saveSearchCardState: 0)
  }
}
