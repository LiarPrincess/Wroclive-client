//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
@testable import Wroclive

// swiftlint:disable implicitly_unwrapped_optional

final class BookmarkCellViewModelTests: XCTestCase {

  // MARK: - Properties

  var viewModel:     BookmarkCellViewModel!
  var testScheduler: TestScheduler!
  var disposeBag:    DisposeBag!

  // MARK: - Init

  override func setUp() {
    super.setUp()
    self.viewModel     = BookmarkCellViewModel()
    self.testScheduler = TestScheduler(initialClock: 0)
    self.disposeBag    = DisposeBag()
  }

  override func tearDown() {
    super.tearDown()
    self.viewModel     = nil
    self.testScheduler = nil
    self.disposeBag    = nil
  }

  // MARK: - Name

  func test_nameChanges_onBookmarkChange() {
    let event0 = next(100, Bookmark(name: "test0", lines: []))
    let event1 = next(200, Bookmark(name: "test1", lines: []))
    self.simulateBookmarkEvents(event0, event1)

    let observer = self.testScheduler.createObserver(String.self)
    self.viewModel.outputs.name
      .drive(observer)
      .disposed(by: self.disposeBag)
    self.testScheduler.start()

    let expectedEvents = [next(100, "test0"), next(200, "test1")]
    XCTAssertEqual(observer.events, expectedEvents)
  }

  // MARK: - Lines

  func test_linesChange_onBookmarkChange() {
    let tram1 = Line(name: "1", type: .tram, subtype: .regular)
    let tram2 = Line(name: "2", type: .tram, subtype: .regular)

    let bus1 = Line(name: "A", type: .bus, subtype: .regular)
    let bus2 = Line(name: "B", type: .bus, subtype: .regular)

    let event0 = next(100, Bookmark(name: "", lines: [tram1, bus1]))
    let event1 = next(200, Bookmark(name: "", lines: [tram1, bus1, tram2, bus2]))
    self.simulateBookmarkEvents(event0, event1)

    let observer = self.testScheduler.createObserver(String.self)
    self.viewModel.outputs.lines
      .drive(observer)
      .disposed(by: self.disposeBag)
    self.testScheduler.start()

    let expectedEvents = [next(100, "1\nA"), next(200, "1   2\nA   B")]
    XCTAssertEqual(observer.events, expectedEvents)
  }
}
