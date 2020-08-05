// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import RxSwift
import RxCocoa
import RxTest
@testable import WrocliveFramework

// swiftlint:disable implicitly_unwrapped_optional

class LineTypeSelectorViewModelTests: XCTestCase, RxTestCase {

  var viewModel: LineTypeSelectorViewModel!

  var pageProp: PublishSubject<LineType>!
  var onPageChangeArgs: [LineType]!

  var selectedIndexObserver: TestableObserver<Int>!

  var scheduler: TestScheduler!
  var disposeBag: DisposeBag!

  override func setUp() {
    super.setUp()
    self.setUpRx()

    self.pageProp = PublishSubject<LineType>()
    self.onPageChangeArgs = []

    self.viewModel = LineTypeSelectorViewModel(
      pageProp: self.pageProp.asObservable(),
      onPageChange: { [unowned self] in self.onPageChangeArgs.append($0) }
    )

    self.selectedIndexObserver = self.scheduler.createObserver(Int.self)
    self.viewModel.selectedIndex.drive(self.selectedIndexObserver).disposed(by: self.disposeBag)
  }

  override func tearDown() {
    super.tearDown()
    self.tearDownRx()
  }

  // MARK: - Data

  private let tramIndex = 0
  private let busIndex  = 1

  private func setPageProp(at time: TestTime, _ value: LineType) {
    self.scheduler.scheduleAt(time) { [unowned self] in
      self.pageProp.asObserver().onNext(value)
    }
  }

  private func didSelectIndex(at time: TestTime, _ value: Int) {
    self.scheduler.scheduleAt(time) { [unowned self] in
      self.viewModel.didSelectIndex.onNext(value)
    }
  }

  // MARK: - Tests

  func test_showsTramsAndBuses() {
    typealias Localization = Localizable.Search

    let pages = self.viewModel.pages

    guard pages.count == 2 else { XCTAssert(false); return }
    XCTAssertEqual(pages[tramIndex], Localization.Pages.tram)
    XCTAssertEqual(pages[busIndex],  Localization.Pages.bus)
  }

  func test_takesPages_fromProps() {
    self.setPageProp(at: 0,   .tram)
    self.setPageProp(at: 100, .bus)
    self.setPageProp(at: 200, .bus) // we should skip this one, as it is the same as previous
    self.setPageProp(at: 300, .tram)

    self.startScheduler()

    let events = self.selectedIndexObserver.events
    guard events.count == 3 else { XCTAssert(false); return }
    XCTAssertEqual(events[0], Recorded.next(0,   tramIndex))
    XCTAssertEqual(events[1], Recorded.next(100, busIndex))
    XCTAssertEqual(events[2], Recorded.next(300, tramIndex))
  }

  func test_changingPageIndex_invokesOnPageChange() {
    self.didSelectIndex(at:   0, tramIndex)
    self.didSelectIndex(at: 100, busIndex)
    self.didSelectIndex(at: 200, -1) // out of bounds
    self.didSelectIndex(at: 300, busIndex)
    self.didSelectIndex(at: 400, 2) // out of bounds
    self.didSelectIndex(at: 500, tramIndex)

    self.startScheduler()

    guard self.onPageChangeArgs.count == 4 else { XCTAssert(false); return }
    XCTAssertEqual(self.onPageChangeArgs[0], .tram)
    XCTAssertEqual(self.onPageChangeArgs[1], .bus)
    XCTAssertEqual(self.onPageChangeArgs[2], .bus)
    XCTAssertEqual(self.onPageChangeArgs[3], .tram)
  }
}
