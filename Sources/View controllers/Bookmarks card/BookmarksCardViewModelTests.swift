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

  var storageManager: StorageManagerMock!

  var viewModel:     BookmarksCardViewModel!
  var testScheduler: TestScheduler!
  var disposeBag:    DisposeBag!

  // MARK: - Init

  override func setUp() {
    super.setUp()

    self.testScheduler = TestScheduler(initialClock: 0)
    self.disposeBag    = DisposeBag()

    self.storageManager = StorageManagerMock()
    EnvironmentStack.push(Environment(storage: self.storageManager))
  }

  override func tearDown() {
    super.tearDown()
    self.testScheduler = nil
    self.disposeBag    = nil
    EnvironmentStack.pop()
  }

  // MARK: - Bookmarks

  func test_startsWithBookmarks_fromManager() {
    let bookmarks = self.testData
    self.storageManager._bookmarks = bookmarks
    self.viewModel = BookmarksCardViewModel()

    let observer = self.testScheduler.createObserver([Bookmark].self)
    viewModel.bookmarks
      .drive(observer)
      .disposed(by: self.disposeBag)
    self.testScheduler.start()

    let expectedEvents = [next(0, bookmarks)]
    XCTAssertEqual(observer.events, expectedEvents)
    XCTAssertOperationCount(self.storageManager, getBookmarks: 1, saveBookmarks: 0)
  }

  func test_movingItem_updatesBookmarks() {
    let bookmarks = self.testData
    self.storageManager._bookmarks = bookmarks
    self.viewModel = BookmarksCardViewModel()

    let event0 = next(100, (from: 0, to: 2))
    let event1 = next(200, (from: 1, to: 0))
    self.simulateMoveEvents(event0, event1)

    let observer = self.testScheduler.createObserver([Bookmark].self)
    viewModel.bookmarks
      .drive(observer)
      .disposed(by: self.disposeBag)
    self.testScheduler.start()

    let expectedEvents = [
      next(  0, bookmarks),
      next(100, [bookmarks[1], bookmarks[2], bookmarks[0]]),
      next(200, [bookmarks[2], bookmarks[1], bookmarks[0]])
    ]

    XCTAssertEqual(observer.events, expectedEvents)
    XCTAssertEqual(self.storageManager._bookmarks, expectedEvents.last!.value.element!)
    XCTAssertOperationCount(self.storageManager, getBookmarks: 1, saveBookmarks: 2)
  }

  func test_deletingItem_updatesBookmarks() {
    let bookmarks = self.testData
    self.storageManager._bookmarks = bookmarks
    self.viewModel = BookmarksCardViewModel()

    let event0 = next(100, 1) // middle
    let event1 = next(200, 1) // last
    let event2 = next(300, 0) // first
    self.simulateDeleteEvents(event0, event1, event2)

    let observer = self.testScheduler.createObserver([Bookmark].self)
    viewModel.bookmarks
      .drive(observer)
      .disposed(by: self.disposeBag)
    self.testScheduler.start()

    let expectedEvents = [
      next(  0, bookmarks),
      next(100, [bookmarks[0], bookmarks[2]]),
      next(200, [bookmarks[0]]),
      next(300, [])
    ]
    XCTAssertEqual(observer.events, expectedEvents)
    XCTAssertEqual(self.storageManager._bookmarks, expectedEvents.last!.value.element!)
    XCTAssertOperationCount(self.storageManager, getBookmarks: 1, saveBookmarks: 3)
  }

  // MARK: - Selection

  func test_selectingItem_startsTracking() {
    let bookmarks = self.testData
    self.storageManager._bookmarks = bookmarks
    self.viewModel = BookmarksCardViewModel()

    let event = next(100, 1)
    self.simulateSelectionEvents(event)

    let observer = self.testScheduler.createObserver(Bookmark.self)
    viewModel.startTracking
      .drive(observer)
      .disposed(by: self.disposeBag)
    self.testScheduler.start()

    let expectedEvents = [next(100, bookmarks[1])]
    XCTAssertEqual(observer.events, expectedEvents)
  }

  // MARK: - IsVisible

  func test_noBookmarks_showsPlaceholder() {
    self.storageManager._bookmarks = []
    self.viewModel = BookmarksCardViewModel()

    let placeholderObserver = self.testScheduler.createObserver(Bool.self)
    viewModel.isPlaceholderVisible
      .drive(placeholderObserver)
      .disposed(by: self.disposeBag)

    let tableViewObserver = self.testScheduler.createObserver(Bool.self)
    viewModel.isTableViewVisible
      .drive(tableViewObserver)
      .disposed(by: self.disposeBag)

    self.testScheduler.start()

    let expectedPlaceholderEvents = [next(0, true)]
    XCTAssertEqual(placeholderObserver.events, expectedPlaceholderEvents)

    let expectedTableViewEvents = self.oppositeVisibility(expectedPlaceholderEvents)
    XCTAssertEqual(tableViewObserver.events, expectedTableViewEvents)
  }

  func test_anyBookmarks_showsTableView() {
    self.storageManager._bookmarks = self.testData
    self.viewModel = BookmarksCardViewModel()

    let placeholderObserver = self.testScheduler.createObserver(Bool.self)
    viewModel.isPlaceholderVisible
      .drive(placeholderObserver)
      .disposed(by: self.disposeBag)

    let tableViewObserver = self.testScheduler.createObserver(Bool.self)
    viewModel.isTableViewVisible
      .drive(tableViewObserver)
      .disposed(by: self.disposeBag)

    self.testScheduler.start()

    let expectedPlaceholderEvents = [next(0, false)]
    XCTAssertEqual(placeholderObserver.events, expectedPlaceholderEvents)

    let expectedTableViewEvents = self.oppositeVisibility(expectedPlaceholderEvents)
    XCTAssertEqual(tableViewObserver.events, expectedTableViewEvents)
  }

  func test_allBookmarksDeleted_showsPlaceholder() {
    self.storageManager._bookmarks = self.testData
    self.viewModel = BookmarksCardViewModel()

    let event0 = next(100, 1) // middle
    let event1 = next(200, 1) // last
    let event2 = next(300, 0) // first
    self.simulateDeleteEvents(event0, event1, event2)

    let placeholderObserver = self.testScheduler.createObserver(Bool.self)
    viewModel.isPlaceholderVisible
      .drive(placeholderObserver)
      .disposed(by: self.disposeBag)

    let tableViewObserver = self.testScheduler.createObserver(Bool.self)
    viewModel.isTableViewVisible
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
    viewModel.isEditing
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
    viewModel.editButtonText
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

// MARK: - Test data

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

  typealias MoveEvent   = Recorded<Event<(from: Int, to: Int)>>
  typealias DeleteEvent = Recorded<Event<Int>>

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

  // MARK: - Selection

  typealias SelectionEvent = Recorded<Event<Int>>

  func simulateSelectionEvents(_ events: SelectionEvent...) {
    self.testScheduler.createHotObservable(events)
      .bind(to: self.viewModel.didSelectItem)
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
    self.testScheduler.createHotObservable(events)
      .bind(to: self.viewModel.didPressEditButton)
      .disposed(by: self.disposeBag)
  }
}
