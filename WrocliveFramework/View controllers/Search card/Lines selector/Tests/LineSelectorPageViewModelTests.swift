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

class LineSelectorPageViewModelTests: XCTestCase, ReduxTestCase, RxTestCase, EnvironmentTestCase {

  var store: Store<AppState>!
  var dispatchedActions: [Action]!

  var scheduler: TestScheduler!
  var disposeBag: DisposeBag!

  var viewModel: LineSelectorPageViewModel!

  var sectionsObserver:        TestableObserver<[LineSelectorSection]>!
  var selectedIndicesObserver: TestableObserver<[IndexPath]>!

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
    self.viewModel = LineSelectorPageViewModel(self.store, for: .tram)

    self.sectionsObserver = self.scheduler.createObserver([LineSelectorSection].self)
    self.viewModel.sections.drive(self.sectionsObserver).disposed(by: self.disposeBag)

    self.selectedIndicesObserver = self.scheduler.createObserver([IndexPath].self)
    self.viewModel.selectedIndices.drive(self.selectedIndicesObserver).disposed(by: self.disposeBag)
  }

  // MARK: - Tests

  func test_withLineResponse_updatesLines() {
    let line0 = Line(name:  "1", type: .tram, subtype: .regular)
    let line1 = Line(name:  "4", type: .tram, subtype: .regular)
    let line2 = Line(name: "20", type: .tram, subtype: .regular)

    self.initViewModel()
    self.setLineResponseState(.none) // empty
    self.setLineResponseState(at: 100, .data([line0, line1]))
    self.setLineResponseState(at: 200, .inProgress) // empty
    self.setLineResponseState(at: 300, .data([line0, line1, line2]))
    self.setLineResponseState(at: 400, .data([line0, line1, line2])) // should skip duplicates
    self.setLineResponseState(at: 500, .error(ApiError.generalError)) // empty
    self.startScheduler()

    let events = self.sectionsObserver.events
    let sectionData = LineSelectorSectionData(for: .regular)

    XCTAssertEqual(events.count, 5)
    XCTAssertEqual(events[0], Recorded.next(0,   []))
    XCTAssertEqual(events[1], Recorded.next(100, [LineSelectorSection(model: sectionData, items: [line0, line1])]))
    XCTAssertEqual(events[2], Recorded.next(200, []))
    XCTAssertEqual(events[3], Recorded.next(300, [LineSelectorSection(model: sectionData, items: [line0, line1, line2])]))
    XCTAssertEqual(events[4], Recorded.next(500, []))
  }

  func test_takesSelectedLines_fromStore() {
    let line0 = Line(name:  "1", type: .tram, subtype: .regular)
    let line1 = Line(name:  "4", type: .tram, subtype: .regular)
    let line2 = Line(name: "20", type: .tram, subtype: .regular)
    self.setLineResponseState(.data([line0, line1, line2]))

    self.initViewModel()
    self.setSelectedLinesState([])
    self.setSelectedLinesState(at: 100, [line0, line2])
    self.setSelectedLinesState(at: 200, [line1, Line(name: "?", type: .tram, subtype: .regular)])
    self.startScheduler()

    let events = self.selectedIndicesObserver.events

    XCTAssertEqual(events.count, 3)
    XCTAssertEqual(events[0], Recorded.next(0,   []))
    XCTAssertEqual(events[1], Recorded.next(100, [IndexPath(item: 0, section: 0), IndexPath(item: 2, section: 0)]))
    XCTAssertEqual(events[2], Recorded.next(200, [IndexPath(item: 1, section: 0)]))
  }

  func test_selectingIndex_dispatchesSelectLineAction() {
    let line0 = Line(name:  "1", type: .tram, subtype: .regular)
    let line1 = Line(name:  "4", type: .tram, subtype: .regular)
    let line2 = Line(name: "20", type: .tram, subtype: .regular)
    self.setLineResponseState(.data([line0, line1, line2]))

    self.initViewModel()
    self.mockDidSelectIndex(at: 100, IndexPath(item: 0, section: 0))
    self.mockDidSelectIndex(at: 200, IndexPath(item: 2, section: 0))
    self.mockDidSelectIndex(at: 300, IndexPath(item: 2, section: 1)) // out of bounds
    self.startScheduler()

    XCTAssertEqual(self.dispatchedActions.count, 2)
    XCTAssertEqual(self.getSearchCardStateSelectLineAction(at: 0), line0)
    XCTAssertEqual(self.getSearchCardStateSelectLineAction(at: 1), line2)
  }

  func test_deselectingLine_dispatchesDeselectLineAction() {
    let line0 = Line(name:  "1", type: .tram, subtype: .regular)
    let line1 = Line(name:  "4", type: .tram, subtype: .regular)
    let line2 = Line(name: "20", type: .tram, subtype: .regular)
    self.setLineResponseState(.data([line0, line1, line2]))

    self.initViewModel()
    self.mockDidDeselectIndex(at: 100, IndexPath(item: 0, section: 0))
    self.mockDidDeselectIndex(at: 200, IndexPath(item: 2, section: 0))
    self.mockDidDeselectIndex(at: 300, IndexPath(item: 2, section: 1)) // out of bounds
    self.startScheduler()

    XCTAssertEqual(self.dispatchedActions.count, 2)
    XCTAssertEqual(self.getSearchCardStateDeselectLineAction(at: 0), line0)
    XCTAssertEqual(self.getSearchCardStateDeselectLineAction(at: 1), line2)
  }

  // MARK: - State

  typealias LineResponse = ApiResponseState<[Line]>

  func setLineResponseState(_ value: LineResponse) {
    self.setLineResponseState(at: 0, value)
  }

  func setLineResponseState(at time: TestTime, _ value: LineResponse) {
    self.scheduler.scheduleAt(time) { [unowned self] in
      self.setState { $0.apiData.lines = value }
    }
  }

  func setSelectedLinesState(_ value: [Line]) {
    self.setSelectedLinesState(at: 0, value)
  }

  func setSelectedLinesState(at time: TestTime, _ value: [Line]) {
    self.scheduler.scheduleAt(time) { [unowned self] in
      self.setState { appState in
        let oldPage = appState.userData.searchCardState.page
        appState.userData.searchCardState = SearchCardState(page: oldPage, selectedLines: value)
      }
    }
  }

  // MARK: - Events

  func mockDidSelectIndex(at time: TestTime, _ value: IndexPath) {
    self.scheduler.scheduleAt(time) { [unowned self] in
      self.viewModel.didSelectIndex.onNext(value)
    }
  }

  func mockDidDeselectIndex(at time: TestTime, _ value: IndexPath) {
    self.scheduler.scheduleAt(time) { [unowned self] in
      self.viewModel.didDeselectIndex.onNext(value)
    }
  }
}
