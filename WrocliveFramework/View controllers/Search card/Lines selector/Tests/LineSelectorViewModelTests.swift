// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import RxSwift
import RxCocoa
import RxTest
@testable import WrocliveFramework

// swiftlint:disable implicitly_unwrapped_optional

class LineSelectorViewModelTests: XCTestCase, RxTestCase {

  var viewModel: LineSelectorViewModel!

  var pageProp: PublishSubject<LineType>!
  var onPageTransitionArgs: [LineType]!

  var pageObserver: TestableObserver<LineType>!

  var scheduler: TestScheduler!
  var disposeBag: DisposeBag!

  override func setUp() {
    super.setUp()
    self.setUpRx()

    self.pageProp = PublishSubject<LineType>()
    self.onPageTransitionArgs = []

    self.viewModel = LineSelectorViewModel(
      pageProp:          self.pageProp.asObservable(),
      linesProp:         .empty(),
      selectedLinesProp: .empty(),
      onPageTransition:  { [unowned self] in self.onPageTransitionArgs.append($0) },
      onLineSelected:    { _ in () },
      onLineDeselected:  { _ in () }
    )

    self.pageObserver = self.scheduler.createObserver(LineType.self)
    self.viewModel.page.drive(self.pageObserver).disposed(by: self.disposeBag)
  }

  override func tearDown() {
    super.tearDown()
    self.tearDownRx()
  }

  // MARK: - Data

  private func setPageProp(at time: TestTime, _ value: LineType) {
    self.scheduler.scheduleAt(time) { [unowned self] in
      self.pageProp.asObserver().onNext(value)
    }
  }

  private func didTransitionToPage(at time: TestTime, _ value: LineType) {
    self.scheduler.scheduleAt(time) { [unowned self] in
      self.viewModel.didTransitionToPage.onNext(value)
    }
  }

  // MARK: - Tests

  func test_takesPage_fromProps() {
    self.setPageProp(at: 0,   .tram)
    self.setPageProp(at: 100, .bus)
    self.setPageProp(at: 200, .bus) // we should skip this one, as it is the same as previous
    self.setPageProp(at: 300, .tram)

    self.startScheduler()

    let events = self.pageObserver.events

    if XCTIfEqual(events.count, 3) {
      XCTAssertEqual(events[0], Recorded.next(0,   LineType.tram))
      XCTAssertEqual(events[1], Recorded.next(100, LineType.bus))
      XCTAssertEqual(events[2], Recorded.next(300, LineType.tram))
    }
  }

  func test_changingPage_invokesOnPageTransition() {
    self.didTransitionToPage(at:   0, LineType.tram)
    self.didTransitionToPage(at: 100, LineType.bus)
    self.didTransitionToPage(at: 200, LineType.bus)
    self.didTransitionToPage(at: 300, LineType.tram)

    self.startScheduler()

    if XCTIfEqual(self.onPageTransitionArgs.count, 4) {
      XCTAssertEqual(self.onPageTransitionArgs[0], .tram)
      XCTAssertEqual(self.onPageTransitionArgs[1], .bus)
      XCTAssertEqual(self.onPageTransitionArgs[2], .bus)
      XCTAssertEqual(self.onPageTransitionArgs[3], .tram)
    }
  }
}
