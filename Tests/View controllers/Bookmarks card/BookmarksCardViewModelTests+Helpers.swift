//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
@testable import Wroclive

extension BookmarksCardViewModelTests {

  // MARK: - Data

  var testData: [Bookmark] {
    let line0 = Line(name:  "1", type: .tram, subtype: .regular)
    let line1 = Line(name:  "4", type: .tram, subtype: .regular)
    let line2 = Line(name: "20", type: .tram, subtype: .regular)
    let line3 = Line(name:  "A", type:  .bus, subtype: .regular)
    let line4 = Line(name:  "D", type:  .bus, subtype: .regular)

    let bookmark0 = Bookmark(name: "Test 0", lines: [line0, line1, line2, line3, line4])
    let bookmark1 = Bookmark(name: "Test 1", lines: [line0, line2, line4])
    let bookmark2 = Bookmark(name: "Test 2", lines: [line0, line2, line3])
    return [bookmark0, bookmark1, bookmark2]
  }

  // MARK: - Bookmarks

  typealias MoveEvent   = Recorded<Event<ItemMovedEvent>>
  typealias DeleteEvent = Recorded<Event<IndexPath>>

  func simulateMoveEvents(_ events: MoveEvent...) {
    testScheduler.createHotObservable(events)
      .bind(to: viewModel.inputs.itemMoved)
      .disposed(by: self.disposeBag)
  }

  func simulateDeleteEvents(_ events: DeleteEvent...) {
    testScheduler.createHotObservable(events)
      .bind(to: viewModel.inputs.itemDeleted)
      .disposed(by: self.disposeBag)
  }

  // MARK: - Selection

  typealias SelectionEvent = Recorded<Event<IndexPath>>

  func simulateSelectionEvents(_ events: SelectionEvent...) {
    testScheduler.createHotObservable(events)
      .bind(to: viewModel.inputs.itemSelected)
      .disposed(by: self.disposeBag)
  }

  // MARK: - Visibility

  typealias VisiblityEvent = Recorded<Event<Bool>>

  func opposite(of events: [VisiblityEvent]) -> [VisiblityEvent] {
    return events.map { next($0.time, !$0.value.element!) }
  }

  // MARK: - Edit

  func simulateEditClickEvents(at times: TestTime...) {
    let events = times.map { next($0, ()) }
    testScheduler.createHotObservable(events)
      .bind(to: viewModel.inputs.editButtonPressed)
      .disposed(by: self.disposeBag)
  }

  // MARK: - Asserts

  func assertBookmarkOperationCount(add: Int, get: Int, save: Int) {
    XCTAssertEqual(self.bookmarksManager.addCount, add)
    XCTAssertEqual(self.bookmarksManager.getCount, get)
    XCTAssertEqual(self.bookmarksManager.saveCount, save)
  }

  typealias VoidEvent    = Recorded<Event<Void>>
  typealias SectionEvent = Recorded<Event<[BookmarksSection]>>

  func assertEqual(_ lhs: [VoidEvent], _ rhs: [VoidEvent]) {
    XCTAssertEqual(lhs.count, rhs.count)

    for (lhsEvent, rhsEvent) in zip(lhs, rhs) {
      XCTAssertEqual(lhsEvent.time, rhsEvent.time)
    }
  }

  func assertEqual(_ lhs: [SectionEvent], _ rhs: [SectionEvent]) {
    XCTAssertEqual(lhs.count, rhs.count)

    for (lhsEvent, rhsEvent) in zip(lhs, rhs) {
      XCTAssertEqual(lhsEvent.time, rhsEvent.time)

      let lhsElement = lhsEvent.value.element!
      let rhsElement = rhsEvent.value.element!
      XCTAssertEqual(lhsElement, rhsElement)
    }
  }

  func assertEqual(_ lhs: [[Line]], _ rhs: [[Line]]) {
    XCTAssertEqual(lhs.count, rhs.count)

    for (lhsLines, rhsLines) in zip(lhs, rhs) {
      XCTAssertEqual(lhsLines, rhsLines)
    }
  }
}
