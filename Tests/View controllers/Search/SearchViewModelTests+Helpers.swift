//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import XCTest
import Foundation
import RxSwift
import RxCocoa
import RxTest
@testable import Wroclive

extension SearchViewModelTests {

  // MARK: - Data

  var testLines: [Line] {
    let line0 = Line(name:  "1", type: .tram, subtype: .regular)
    let line1 = Line(name:  "4", type: .tram, subtype: .regular)
    let line2 = Line(name: "20", type: .tram, subtype: .regular)
    let line3 = Line(name:  "A", type:  .bus, subtype: .regular)
    let line4 = Line(name:  "D", type:  .bus, subtype: .regular)
    return [line0, line1, line2, line3, line4]
  }

  // MARK: - Page

  typealias LineTypeSelectorPageChangedEvent = Recorded<Event<LineType>>
  typealias LineSelectorPageChangedEvent     = Recorded<Event<LineType>>

  func simulateLineTypeSelectorPageChangedEvents(_ events: LineTypeSelectorPageChangedEvent...) {
    testScheduler.createHotObservable(events)
      .bind(to: self.viewModel.inputs.lineTypeSelectorPageChanged)
      .disposed(by: self.disposeBag)
  }

  func simulateLineSelectorPageChangedEvents(_ events: LineSelectorPageChangedEvent...) {
    testScheduler.createHotObservable(events)
      .bind(to: self.viewModel.inputs.lineSelectorPageChanged)
      .disposed(by: self.disposeBag)
  }

  // MARK: - Lines

  // MARK: - Buttons

  func simulateBookmarkButtonPressedEvents(at times: TestTime...) {
    let events = times.map { next($0, ()) }
    testScheduler.createHotObservable(events)
      .bind(to: self.viewModel.inputs.bookmarkButtonPressed)
      .disposed(by: self.disposeBag)
  }

  func simulateSearchButtonPressedEvents(at times: TestTime...) {
    let events = times.map { next($0, ()) }
    testScheduler.createHotObservable(events)
      .bind(to: self.viewModel.inputs.searchButtonPressed)
      .disposed(by: self.disposeBag)
  }

  // MARK: - Close

  func simulateDidCloseEvents(at times: TestTime...) {
    let events = times.map { next($0, ()) }
    testScheduler.createHotObservable(events)
      .bind(to: self.viewModel.inputs.didClose)
      .disposed(by: self.disposeBag)
  }

  // MARK: - Asserts

  typealias VoidEvent = Recorded<Event<Void>>

  func assertSearchOperationCount(get: Int, save: Int) {
    XCTAssertEqual(self.searchManager.getStateCount, get)
    XCTAssertEqual(self.searchManager.saveCount, save)
  }

  func assertEqual(_ lhs: [VoidEvent], _ rhs: [VoidEvent]) {
    XCTAssertEqual(lhs.count, rhs.count)

    for (lhsEvent, rhsEvent) in zip(lhs, rhs) {
      XCTAssertEqual(lhsEvent.time, rhsEvent.time)
    }
  }
}
