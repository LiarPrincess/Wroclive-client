// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import RxSwift
import RxCocoa
import RxTest
import ReSwift
@testable import WrocliveFramework

// swiftlint:disable implicitly_unwrapped_optional

class LineSelectorViewModelTests: XCTestCase, ReduxTestCase, RxTestCase, EnvironmentTestCase {

  var store: Store<AppState>!
  var dispatchedActions: [Action]!

  var scheduler: TestScheduler!
  var disposeBag: DisposeBag!

  var viewModel: LineSelectorViewModel!

  var pageObserver: TestableObserver<LineType>!

  override func setUp() {
    super.setUp()
    self.setUpRedux()
    self.setUpRx()
    self.setUpEnvironment()
  }

  override func tearDown() {
    super.tearDown()
    self.tearDownEnvironment()
    self.tearDownRx()
    self.tearDownRedux()
  }

  func initViewModel() {
    self.viewModel = LineSelectorViewModel(self.store)

    self.pageObserver = self.scheduler.createObserver(LineType.self)
    self.viewModel.page.drive(self.pageObserver).disposed(by: self.disposeBag)
  }

  // MARK: - Data

  func setState(_ state: LineType) {
    self.setState { $0.userData.searchCardState = SearchCardState(page: state, selectedLines: []) }
  }

  func mockPageTransition(at time: TestTime, _ value: LineType) {
    self.scheduler.scheduleAt(time) { [unowned self] in
      self.viewModel.didTransitionToPage.onNext(value)
    }
  }

  // MARK: - Tests

  func test_takesPage_fromStore() {
    let page0 = LineType.tram
    let page1 = LineType.bus
    let page2 = LineType.bus // we should skip this one, as it is the same as previous
    let page3 = LineType.tram

    self.setState(page0)
    self.scheduler.scheduleAt(100) { [unowned self] in self.setState(page1) }
    self.scheduler.scheduleAt(200) { [unowned self] in self.setState(page2) }
    self.scheduler.scheduleAt(300) { [unowned self] in self.setState(page3) }

    self.initViewModel()
    self.startScheduler()

    XCTAssertEqual(self.pageObserver.events, [
      Recorded.next(0,   LineType.tram),
      Recorded.next(100, LineType.bus),
      Recorded.next(300, LineType.tram)
    ])

    XCTAssertEqual(self.storageMock.getSearchCardStateCount, 0) // we should get them from store
    XCTAssertEqual(self.storageMock.saveSearchCardStateCount, 0)
  }

  func test_changingPage_dispatchesSelectPageAction() {
    self.setState(LineType.tram)

    self.initViewModel()
    self.mockPageTransition(at: 100, .tram)
    self.mockPageTransition(at: 200, .bus)
    self.mockPageTransition(at: 300, .bus)
    self.mockPageTransition(at: 400, .tram)

    self.startScheduler()

    XCTAssertEqual(self.dispatchedActions.count, 4)
    XCTAssertEqual(self.getSearchCardStateSelectPageAction(at: 0), LineType.tram)
    XCTAssertEqual(self.getSearchCardStateSelectPageAction(at: 1), LineType.bus)
    XCTAssertEqual(self.getSearchCardStateSelectPageAction(at: 2), LineType.bus)
    XCTAssertEqual(self.getSearchCardStateSelectPageAction(at: 3), LineType.tram)

    XCTAssertEqual(self.storageMock.getSearchCardStateCount, 0) // we should get them from store
    XCTAssertEqual(self.storageMock.saveSearchCardStateCount, 0)
  }
}
