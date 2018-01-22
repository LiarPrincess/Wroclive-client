//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
@testable import Wroclive

// swiftlint:disable file_length
// swiftlint:disable implicitly_unwrapped_optional

private typealias TextStyles   = BookmarksCardConstants.TextStyles
private typealias Localization = Localizable.Bookmarks

final class BookmarksCardViewModelTests: XCTestCase {

  // MARK: - Properties

  var bookmarksManager: BookmarksManagerMock!
  var trackingManager:  TrackingManagerMock!

  var viewModel:        BookmarksCardViewModel!
  var testScheduler:    TestScheduler!
  var disposeBag:       DisposeBag!

  // MARK: - Init

  override func setUp() {
    super.setUp()

    self.testScheduler = TestScheduler(initialClock: 0)
    self.disposeBag    = DisposeBag()

    self.bookmarksManager = BookmarksManagerMock(bookmarks: [])
    self.trackingManager  = TrackingManagerMock()
    AppEnvironment.push(bookmarks: self.bookmarksManager, tracking: self.trackingManager)
  }

  override func tearDown() {
    super.tearDown()
    self.testScheduler = nil
    self.disposeBag    = nil
    AppEnvironment.pop()
  }

  // MARK: - Bookmarks

  func test_containsItemsFromManager() {
    let bookmarks = self.testData
    self.bookmarksManager.bookmarks = bookmarks
    self.viewModel = BookmarksCardViewModel()

    let observer = self.testScheduler.createObserver([BookmarksSection].self)
    viewModel.outputs.bookmarks
      .drive(observer)
      .disposed(by: self.disposeBag)
    self.testScheduler.start()

    let expectedEvents = [next(0, [BookmarksSection(model: "", items: bookmarks)])]
    XCTAssertEqual(observer.events, expectedEvents)
    XCTAssertOperationCount(self.bookmarksManager, add: 0, get: 1, save: 0)
  }

  func test_movingItem_updatesItems() {
    let bookmarks = self.testData
    self.bookmarksManager.bookmarks = bookmarks
    self.viewModel = BookmarksCardViewModel()

    let event0 = next(100, ItemMovedEvent(IndexPath(item: 0, section: 0), IndexPath(item: 2, section: 0)))
    let event1 = next(200, ItemMovedEvent(IndexPath(item: 1, section: 0), IndexPath(item: 0, section: 0)))
    self.simulateMoveEvents(event0, event1)

    let observer = self.testScheduler.createObserver([BookmarksSection].self)
    viewModel.outputs.bookmarks
      .drive(observer)
      .disposed(by: self.disposeBag)
    self.testScheduler.start()

    let expectedEvents = [
      next(  0, [BookmarksSection(model: "", items: bookmarks)]),
      next(100, [BookmarksSection(model: "", items: [bookmarks[1], bookmarks[2], bookmarks[0]])]),
      next(200, [BookmarksSection(model: "", items: [bookmarks[2], bookmarks[1], bookmarks[0]])])
    ]
    XCTAssertEqual(observer.events, expectedEvents)
    XCTAssertOperationCount(self.bookmarksManager, add: 0, get: 1, save: 2)
  }

  func test_deletingItem_updatesItems() {
    let bookmarks = self.testData
    self.bookmarksManager.bookmarks = bookmarks
    self.viewModel = BookmarksCardViewModel()

    let event0 = next(100, IndexPath(item: 1, section: 0)) // middle
    let event1 = next(200, IndexPath(item: 1, section: 0)) // last
    let event2 = next(300, IndexPath(item: 0, section: 0)) // first
    self.simulateDeleteEvents(event0, event1, event2)

    let observer = self.testScheduler.createObserver([BookmarksSection].self)
    viewModel.outputs.bookmarks
      .drive(observer)
      .disposed(by: self.disposeBag)
    self.testScheduler.start()

    let expectedEvents = [
      next(  0, [BookmarksSection(model: "", items: bookmarks)]),
      next(100, [BookmarksSection(model: "", items: [bookmarks[0], bookmarks[2]])]),
      next(200, [BookmarksSection(model: "", items: [bookmarks[0]])]),
      next(300, [BookmarksSection(model: "", items: [])])
    ]
    XCTAssertEqual(observer.events, expectedEvents)
    XCTAssertOperationCount(self.bookmarksManager, add: 0, get: 1, save: 3)
  }

  // MARK: - Selection

  func test_selectingItem_startsTracking() {
    let bookmarks = self.testData
    self.bookmarksManager.bookmarks = bookmarks
    self.viewModel = BookmarksCardViewModel()

    let event0 = next(100, IndexPath(item: 0, section: 0)) // first
    let event1 = next(200, IndexPath(item: 1, section: 0)) // middle
    self.simulateSelectionEvents(event0, event1)

    self.testScheduler.start()

    let expectedLines = [bookmarks[0].lines, bookmarks[1].lines]
    XCTAssertEqual(self.trackingManager.trackedLines, expectedLines)
  }

  func test_selectingItem_closes() {
    self.bookmarksManager.bookmarks = self.testData
    self.viewModel = BookmarksCardViewModel()

    let event0 = next(100, IndexPath(item: 0, section: 0)) // first
    let event1 = next(200, IndexPath(item: 1, section: 0)) // middle
    self.simulateSelectionEvents(event0, event1)

    let observer = self.testScheduler.createObserver(Void.self)
    viewModel.outputs.shouldClose
      .drive(observer)
      .disposed(by: self.disposeBag)
    self.testScheduler.start()

    let expectedEvents = [next(100, ()), next(200, ())]
    XCTAssertEqual(observer.events, expectedEvents)
  }

  // MARK: - IsVisible

  func test_onEmptyBookmarks_showsPlaceholder() {
    self.bookmarksManager.bookmarks = []
    self.viewModel = BookmarksCardViewModel()

    let placeholderObserver = self.testScheduler.createObserver(Bool.self)
    viewModel.outputs.isPlaceholderVisible
      .drive(placeholderObserver)
      .disposed(by: self.disposeBag)

    let tableViewObserver = self.testScheduler.createObserver(Bool.self)
    viewModel.outputs.isTableViewVisible
      .drive(tableViewObserver)
      .disposed(by: self.disposeBag)

    self.testScheduler.start()

    let expectedPlaceholderEvents = [next(0, true)]
    XCTAssertEqual(placeholderObserver.events, expectedPlaceholderEvents)

    let expectedTableViewEvents = self.oppositeVisibility(expectedPlaceholderEvents)
    XCTAssertEqual(tableViewObserver.events, expectedTableViewEvents)
  }

  func test_onAnyBookmarks_showsTableView() {
    self.bookmarksManager.bookmarks = self.testData
    self.viewModel = BookmarksCardViewModel()

    let placeholderObserver = self.testScheduler.createObserver(Bool.self)
    viewModel.outputs.isPlaceholderVisible
      .drive(placeholderObserver)
      .disposed(by: self.disposeBag)

    let tableViewObserver = self.testScheduler.createObserver(Bool.self)
    viewModel.outputs.isTableViewVisible
      .drive(tableViewObserver)
      .disposed(by: self.disposeBag)

    self.testScheduler.start()

    let expectedPlaceholderEvents = [next(0, false)]
    XCTAssertEqual(placeholderObserver.events, expectedPlaceholderEvents)

    let expectedTableViewEvents = self.oppositeVisibility(expectedPlaceholderEvents)
    XCTAssertEqual(tableViewObserver.events, expectedTableViewEvents)
  }

  func test_onAllBookmarksDeleted_showsPlaceholder() {
    self.bookmarksManager.bookmarks = self.testData
    self.viewModel = BookmarksCardViewModel()

    let event0 = next(100, IndexPath(item: 1, section: 0)) // middle
    let event1 = next(200, IndexPath(item: 1, section: 0)) // last
    let event2 = next(300, IndexPath(item: 0, section: 0)) // first
    self.simulateDeleteEvents(event0, event1, event2)

    let placeholderObserver = self.testScheduler.createObserver(Bool.self)
    viewModel.outputs.isPlaceholderVisible
      .drive(placeholderObserver)
      .disposed(by: self.disposeBag)

    let tableViewObserver = self.testScheduler.createObserver(Bool.self)
    viewModel.outputs.isTableViewVisible
      .drive(tableViewObserver)
      .disposed(by: self.disposeBag)

    self.testScheduler.start()

    let expectedPlaceholderEvents = [next(0, false), next(100, false), next(200, false), next(300, true)]
    XCTAssertEqual(placeholderObserver.events, expectedPlaceholderEvents)

    let expectedTableViewEvents = self.oppositeVisibility(expectedPlaceholderEvents)
    XCTAssertEqual(tableViewObserver.events, expectedTableViewEvents)
  }

  // MARK: - Edit

  func test_editButton_changesIsEditing() {
    self.viewModel = BookmarksCardViewModel()
    self.simulateEditClickEvents(at: 100, 200)

    let observer = self.testScheduler.createObserver(Bool.self)
    viewModel.outputs.isEditing
      .drive(observer)
      .disposed(by: self.disposeBag)
    self.testScheduler.start()

    let expectedEvents = [next(0, false), next(100, true), next(200, false)]
    XCTAssertEqual(observer.events, expectedEvents)
  }

  func test_editButton_updatesEditButtonText() {
    self.viewModel = BookmarksCardViewModel()
    self.simulateEditClickEvents(at: 100, 200)

    let observer = self.testScheduler.createObserver(NSAttributedString.self)
    viewModel.outputs.editButtonText
      .drive(observer)
      .disposed(by: self.disposeBag)
    self.testScheduler.start()

    let expectedEvents = [
      next(  0, NSAttributedString(string: Localization.Edit.edit, attributes: TextStyles.Edit.edit)),
      next(100, NSAttributedString(string: Localization.Edit.done, attributes: TextStyles.Edit.done)),
      next(200, NSAttributedString(string: Localization.Edit.edit, attributes: TextStyles.Edit.edit))
    ]
    XCTAssertEqual(observer.events, expectedEvents)
  }
}

// MARK: - Data

extension BookmarksCardViewModelTests {
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
}

// MARK: - Events

extension BookmarksCardViewModelTests {

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

  func oppositeVisibility(_ events: [VisiblityEvent]) -> [VisiblityEvent] {
    return events.map { next($0.time, !$0.value.element!) }
  }

  // MARK: - Edit

  func simulateEditClickEvents(at times: TestTime...) {
    let events = times.map { next($0, ()) }
    testScheduler.createHotObservable(events)
      .bind(to: viewModel.inputs.editButtonPressed)
      .disposed(by: self.disposeBag)
  }
}

// MARK: - Asserts

private typealias VoidEvent = Recorded<Event<Void>>

private func XCTAssertEqual(_ lhs: [VoidEvent], _ rhs: [VoidEvent], file: StaticString = #file, line: UInt = #line) {
  XCTAssertEqual(lhs.count, rhs.count, file: file, line: line)

  for (lhsEvent, rhsEvent) in zip(lhs, rhs) {
    XCTAssertEqual(lhsEvent.time, rhsEvent.time, file: file, line: line)
  }
}

private typealias SectionEvent = Recorded<Event<[BookmarksSection]>>

private func XCTAssertEqual(_ lhs: [SectionEvent], _ rhs: [SectionEvent], file: StaticString = #file, line: UInt = #line) {
  XCTAssertEqual(lhs.count, rhs.count, file: file, line: line)

  for (lhsEvent, rhsEvent) in zip(lhs, rhs) {
    XCTAssertEqual(lhsEvent.time, rhsEvent.time, file: file, line: line)

    let lhsElement = lhsEvent.value.element!
    let rhsElement = rhsEvent.value.element!
    XCTAssertEqual(lhsElement, rhsElement, file: file, line: line)
  }
}

private func XCTAssertEqual(_ lhs: [[Line]], _ rhs: [[Line]], file: StaticString = #file, line: UInt = #line) {
  XCTAssertEqual(lhs.count, rhs.count, file: file, line: line)

  for (lhsLines, rhsLines) in zip(lhs, rhs) {
    XCTAssertEqual(lhsLines, rhsLines, file: file, line: line)
  }
}
