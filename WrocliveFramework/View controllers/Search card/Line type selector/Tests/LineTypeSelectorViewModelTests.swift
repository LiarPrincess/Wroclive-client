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

class LineTypeSelectorViewModelTests: XCTestCase, ReduxTestCase, RxTestCase, EnvironmentTestCase {

  var store: Store<AppState>!
  var dispatchedActions: [Action]!

  var scheduler: TestScheduler!
  var disposeBag: DisposeBag!

  var viewModel: LineTypeSelectorViewModel!

  var selectedIndexObserver: TestableObserver<Int>!

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
    self.viewModel = LineTypeSelectorViewModel(self.store)

    self.selectedIndexObserver = self.scheduler.createObserver(Int.self)
    self.viewModel.selectedIndex.drive(self.selectedIndexObserver).disposed(by: self.disposeBag)
  }

  // MARK: - Data

  private let tramIndex = 0
  private let busIndex  = 1

  func setState(_ state: LineType) {
    self.setState { $0.userData.searchCardState = SearchCardState(page: state, selectedLines: []) }
  }

  // MARK: - Tests

  func test_takesPageIndexState_fromStore() {
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

    XCTAssertEqual(self.selectedIndexObserver.events, [
      Recorded.next(0,   tramIndex),
      Recorded.next(100, busIndex),
      Recorded.next(300, tramIndex)
    ])

    XCTAssertEqual(self.storageMock.getSearchCardStateCount, 0) // we should get them from store
    XCTAssertEqual(self.storageMock.saveSearchCardStateCount, 0)
  }

  func test_changingPageIndex_dispatchesSelectPageAction() {
    self.setState(LineType.tram)

    self.initViewModel()
    self.mockPageSelected(at: 100, tramIndex)
    self.mockPageSelected(at: 200, busIndex)
    self.mockPageSelected(at: 300, busIndex)
    self.mockPageSelected(at: 400, tramIndex)

    self.startScheduler()

    XCTAssertEqual(self.dispatchedActions.count, 4)
    XCTAssertEqual(self.getSearchCardStateSelectPageAction(at: 0), LineType.tram)
    XCTAssertEqual(self.getSearchCardStateSelectPageAction(at: 1), LineType.bus)
    XCTAssertEqual(self.getSearchCardStateSelectPageAction(at: 2), LineType.bus)
    XCTAssertEqual(self.getSearchCardStateSelectPageAction(at: 3), LineType.tram)

    XCTAssertEqual(self.storageMock.getSearchCardStateCount, 0) // we should get them from store
    XCTAssertEqual(self.storageMock.saveSearchCardStateCount, 0)
  }

  func mockPageSelected(at time: TestTime, _ value: Int) {
    self.scheduler.scheduleAt(time) { [unowned self] in
      self.viewModel.didSelectIndex.onNext(value)
    }
  }
}
