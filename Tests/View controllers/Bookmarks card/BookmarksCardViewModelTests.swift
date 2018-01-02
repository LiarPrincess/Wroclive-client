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

  func test_containsItems_fromManager() {
    let bookmarks = self.testData
    self.bookmarksManager.bookmarks = bookmarks
    self.viewModel = BookmarksCardViewModel()

    let observer = self.testScheduler.createObserver([BookmarksSection].self)
    viewModel.outputs.bookmarks
      .drive(observer)
      .disposed(by: self.disposeBag)
    self.testScheduler.start()

    let expectedEvents = [next(0, [BookmarksSection(model: "", items: bookmarks)])]
    self.assertEqual(observer.events, expectedEvents)
    self.assertBookmarkOperationCount(add: 0, get: 1, save: 0)
  }

  func test_updatesItems_onMove() {
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
    self.assertEqual(observer.events, expectedEvents)
    self.assertBookmarkOperationCount(add: 0, get: 1, save: 2)
  }

  func test_updatesItems_onDelete() {
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
    self.assertEqual(observer.events, expectedEvents)
    self.assertBookmarkOperationCount(add: 0, get: 1, save: 3)
  }

  // MARK: - Selection

  func test_startsTracking_onItemSelected() {
    let bookmarks = self.testData
    self.bookmarksManager.bookmarks = bookmarks
    self.viewModel = BookmarksCardViewModel()

    let event0 = next(100, IndexPath(item: 0, section: 0)) // first
    let event1 = next(200, IndexPath(item: 1, section: 0)) // middle
    self.simulateSelectionEvents(event0, event1)

    self.testScheduler.start()

    let expectedLines = [bookmarks[0].lines, bookmarks[1].lines]
    self.assertEqual(self.trackingManager.requestedLines, expectedLines)
  }

  func test_closes_onItemSelected() {
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
    self.assertEqual(observer.events, expectedEvents)
  }

  // MARK: - IsVisible

  func test_showsPlaceholder_whenNoBookmarks() {
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

    let expectedTableViewEvents = self.opposite(of: expectedPlaceholderEvents)
    XCTAssertEqual(tableViewObserver.events, expectedTableViewEvents)
  }

  func test_showsTableView_whenBookmarksPresent() {
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

    let expectedTableViewEvents = self.opposite(of: expectedPlaceholderEvents)
    XCTAssertEqual(tableViewObserver.events, expectedTableViewEvents)
  }

  func test_showsPlaceholder_whenAllBookmarksDeleted() {
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

    let expectedTableViewEvents = self.opposite(of: expectedPlaceholderEvents)
    XCTAssertEqual(tableViewObserver.events, expectedTableViewEvents)
  }

  // MARK: - Edit

  func test_changesIsEditing_onEditClick() {
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

  func test_changesEditButtonText_onEditClick() {
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
