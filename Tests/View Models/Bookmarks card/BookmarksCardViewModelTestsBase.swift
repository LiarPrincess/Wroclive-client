// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import RxSwift
import RxCocoa
import RxTest
@testable import Wroclive

// swiftlint:disable implicitly_unwrapped_optional

class BookmarksCardViewModelTestsBase: XCTestCase {

  var storageManager: StorageManagerMock!

  var viewModel:     BookmarksCardViewModel!
  var testScheduler: TestScheduler!
  var disposeBag:    DisposeBag!

  override func setUp() {
    super.setUp()

    self.testScheduler = TestScheduler(initialClock: 0)
    self.disposeBag    = DisposeBag()

    self.storageManager = StorageManagerMock()
    AppEnvironment.push(storage: self.storageManager)
  }

  override func tearDown() {
    super.tearDown()
    self.testScheduler = nil
    self.disposeBag    = nil
    AppEnvironment.pop()
  }

  // MARK: - Test data

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

  // MARK: - Events

  typealias SelectionEvent = Recorded<Event<Int>>
  typealias MoveEvent      = Recorded<Event<(from: Int, to: Int)>>
  typealias DeleteEvent    = Recorded<Event<Int>>

  func simulateMoveEvents(_ events: MoveEvent...) {
    self.testScheduler.createHotObservable(events)
      .bind(to: self.viewModel.didMoveItem)
      .disposed(by: self.disposeBag)
  }

  func simulateDeleteEvents(_ events: DeleteEvent...) {
    self.testScheduler.createHotObservable(events)
      .bind(to: viewModel.didDeleteItem)
      .disposed(by: self.disposeBag)
  }

  func simulateEditClickEvents(at times: TestTime...) {
    let events = times.map { next($0, ()) }
    self.testScheduler.createHotObservable(events)
      .bind(to: self.viewModel.didPressEditButton)
      .disposed(by: self.disposeBag)
  }

  func simulateSelectionEvents(_ events: SelectionEvent...) {
    self.testScheduler.createHotObservable(events)
      .bind(to: self.viewModel.didSelectItem)
      .disposed(by: self.disposeBag)
  }
}
