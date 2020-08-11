// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import RxSwift
import RxCocoa
import RxTest
@testable import WrocliveFramework

// swiftlint:disable implicitly_unwrapped_optional

class LineSelectorPageViewModelTests: XCTestCase, RxTestCase {

  var viewModel: LineSelectorPageViewModel!

  var linesProp:         PublishSubject<[Line]>!
  var selectedLinesProp: PublishSubject<[Line]>!
  var onLineSelectedArgs:   [Line]!
  var onLineDeselectedArgs: [Line]!

  var sectionsObserver:        TestableObserver<[LineSelectorSection]>!
  var selectedIndicesObserver: TestableObserver<[IndexPath]>!

  var scheduler: TestScheduler!
  var disposeBag: DisposeBag!

  override func setUp() {
    super.setUp()
    self.setUpRx()

    self.linesProp         = PublishSubject<[Line]>()
    self.selectedLinesProp = PublishSubject<[Line]>()
    self.onLineSelectedArgs   = []
    self.onLineDeselectedArgs = []

    self.viewModel = LineSelectorPageViewModel(
      linesProp:         self.linesProp.asObservable(),
      selectedLinesProp: self.selectedLinesProp.asObservable(),
      onLineSelected:    { [unowned self] in self.onLineSelectedArgs.append($0) },
      onLineDeselected:  { [unowned self] in self.onLineDeselectedArgs.append($0) }
    )

    self.sectionsObserver = self.scheduler.createObserver([LineSelectorSection].self)
    self.viewModel.sections.drive(self.sectionsObserver).disposed(by: self.disposeBag)

    self.selectedIndicesObserver = self.scheduler.createObserver([IndexPath].self)
    self.viewModel.selectedIndices.drive(self.selectedIndicesObserver).disposed(by: self.disposeBag)
  }

  override func tearDown() {
    super.tearDown()
    self.tearDownRx()
  }

  // MARK: - Data

  private func setLinesProp(at time: TestTime, _ value: [Line]) {
    self.scheduler.scheduleAt(time) { [unowned self] in
      self.linesProp.asObserver().onNext(value)
    }
  }

  private func setSelectedLinesProp(at time: TestTime, _ value: [Line]) {
    self.scheduler.scheduleAt(time) { [unowned self] in
      self.selectedLinesProp.asObserver().onNext(value)
    }
  }

  func didSelectIndex(at time: TestTime, _ value: IndexPath) {
    self.scheduler.scheduleAt(time) { [unowned self] in
      self.viewModel.didSelectIndex.onNext(value)
    }
  }

  func didDeselectIndex(at time: TestTime, _ value: IndexPath) {
    self.scheduler.scheduleAt(time) { [unowned self] in
      self.viewModel.didDeselectIndex.onNext(value)
    }
  }

  // MARK: - Tests

  func test_takesLines_fromProps() {
    let line0 = Line(name:  "1", type: .tram, subtype: .regular)
    let line1 = Line(name:  "4", type: .tram, subtype: .regular)
    let line2 = Line(name: "20", type: .tram, subtype: .regular)

    self.setLinesProp(at: 0,   [])
    self.setLinesProp(at: 100, [line0, line1])
    self.setLinesProp(at: 200, [line0, line1, line2])
    self.setLinesProp(at: 300, [line0, line1, line2]) // should skip duplicates
    self.setLinesProp(at: 400, [])
    self.startScheduler()

    // the exact details how sections are created are in 'LineSelectorSectionCreator',
    // so we not have to test them here
    let events = self.sectionsObserver.events
    let sectionData = LineSelectorSectionData(for: .regular)

    if XCTIfEqual(events.count, 4) {
      XCTAssertEqual(events[0], Recorded.next(0,   []))
      XCTAssertEqual(events[1], Recorded.next(100, [LineSelectorSection(model: sectionData, items: [line0, line1])]))
      XCTAssertEqual(events[2], Recorded.next(200, [LineSelectorSection(model: sectionData, items: [line0, line1, line2])]))
      XCTAssertEqual(events[3], Recorded.next(400, []))
    }
  }

  func test_takesSelectedLines_fromProps() {
    let line0 = Line(name:  "1", type: .tram, subtype: .regular)
    let line1 = Line(name:  "4", type: .tram, subtype: .regular)
    let line2 = Line(name: "20", type: .tram, subtype: .regular)

    // Because of how UICollectionView works we need re-post selectedIndices every time lines change
    self.setLinesProp(at: 0, [line0, line1, line2])
    self.setSelectedLinesProp(at: 100, [])
    self.setSelectedLinesProp(at: 200, [line0, line2])
    self.setSelectedLinesProp(at: 300, [line1, Line(name: "?", type: .tram, subtype: .regular)])
    self.setLinesProp(at: 400, [line0, line1])
    self.startScheduler()

    let events = self.selectedIndicesObserver.events

    if XCTIfEqual(events.count, 5) {
      // setting lines
      XCTAssertEqual(events[0], Recorded.next(0, []))
      // setting selected lines
      XCTAssertEqual(events[1], Recorded.next(100, [])) // technically, this one does not have to be here
      XCTAssertEqual(events[2], Recorded.next(200, [IndexPath(item: 0, section: 0), IndexPath(item: 2, section: 0)]))
      XCTAssertEqual(events[3], Recorded.next(300, [IndexPath(item: 1, section: 0)]))
      // setting lines again (re-post mentioned before)
      XCTAssertEqual(events[4], Recorded.next(400, [IndexPath(item: 1, section: 0)]))
    }
  }

  func test_selectingIndex_invokesOnLineSelected() {
    let line0 = Line(name:  "1", type: .tram, subtype: .regular)
    let line1 = Line(name:  "4", type: .tram, subtype: .regular)
    let line2 = Line(name: "20", type: .tram, subtype: .regular)
    self.setLinesProp(at: 0, [line0, line1, line2])

    self.didSelectIndex(at: 100, IndexPath(item: 0, section: 0))
    self.didSelectIndex(at: 200, IndexPath(item: 2, section: 0))
    self.didSelectIndex(at: 300, IndexPath(item: 2, section: 1)) // out of bounds
    self.startScheduler()

    if XCTIfEqual(self.onLineSelectedArgs.count, 2) {
      XCTAssertEqual(self.onLineSelectedArgs[0], line0)
      XCTAssertEqual(self.onLineSelectedArgs[1], line2)
    }

    XCTAssertEqual(self.onLineDeselectedArgs.count, 0)
  }

  func test_deselectingIndex_invokesOnLineDeselected() {
    let line0 = Line(name:  "1", type: .tram, subtype: .regular)
    let line1 = Line(name:  "4", type: .tram, subtype: .regular)
    let line2 = Line(name: "20", type: .tram, subtype: .regular)
    self.setLinesProp(at: 0, [line0, line1, line2])

    self.didDeselectIndex(at: 100, IndexPath(item: 0, section: 0))
    self.didDeselectIndex(at: 200, IndexPath(item: 2, section: 0))
    self.didDeselectIndex(at: 300, IndexPath(item: 2, section: 1)) // out of bounds
    self.startScheduler()

    XCTAssertEqual(self.onLineSelectedArgs.count, 0)

    if XCTIfEqual(self.onLineDeselectedArgs.count, 2) {
      XCTAssertEqual(self.onLineDeselectedArgs[0], line0)
      XCTAssertEqual(self.onLineDeselectedArgs[1], line2)
    }
  }
}
