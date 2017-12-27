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

private typealias TextStyles   = BookmarksViewControllerConstants.TextStyles
private typealias Localization = Localizable.Bookmarks

final class BookmarksViewModelTests: XCTestCase {

  // MARK: - Properties

  var bookmarksManager: BookmarksManagerMock!
  var testScheduler:    TestScheduler!
  let disposeBag = DisposeBag()

  // MARK: Init

  override func setUp() {
    super.setUp()

    self.testScheduler = TestScheduler(initialClock: 0)

    self.bookmarksManager = BookmarksManagerMock(bookmarks: [])
    AppEnvironment.push(bookmarks: self.bookmarksManager)
  }

  override func tearDown() {
    super.tearDown()
    self.testScheduler = nil
    AppEnvironment.pop()
  }

  // MARK: - Items

  func test_containsItems_fromBookmarkManager() {
    let bookmarks = self.testData
    self.bookmarksManager.bookmarks = bookmarks
    let viewModel = BookmarksViewModel()

    let observer = self.testScheduler.createObserver([BookmarksSection].self)
    viewModel.outputs.items
      .drive(observer)
      .disposed(by: self.disposeBag)
    self.testScheduler.start()

    let expectedEvents = [next(0, [BookmarksSection(model: "", items: bookmarks)])]
    self.assertEqual(observer.events, expectedEvents)
  }

  // MARK: - Selection

  func test_selectsItem_onItemSelected() {
    let bookmarks = self.testData
    self.bookmarksManager.bookmarks = bookmarks
    let viewModel = BookmarksViewModel()

    let event0 = next(100, IndexPath(item: 0, section: 0)) // first
    let event1 = next(200, IndexPath(item: 1, section: 0)) // middle
    self.simulateSelectionEvents(in: viewModel, events: [event0, event1])

    let observer = self.testScheduler.createObserver(Bookmark.self)
    viewModel.outputs.selectedItem
      .drive(observer)
      .disposed(by: self.disposeBag)
    self.testScheduler.start()

    let expectedEvents = [next(100, bookmarks[0]), next(200, bookmarks[1])]
    XCTAssertEqual(observer.events, expectedEvents)
  }

  // MARK: - Move

  func test_updatesItems_onItemMoved() {
    let bookmarks = self.testData
    self.bookmarksManager.bookmarks = bookmarks
    let viewModel = BookmarksViewModel()

    let event0 = next(100, ItemMovedEvent(IndexPath(item: 0, section: 0), IndexPath(item: 2, section: 0)))
    let event1 = next(200, ItemMovedEvent(IndexPath(item: 1, section: 0), IndexPath(item: 0, section: 0)))
    self.simulateMoveEvents(in: viewModel, events: [event0, event1])

    let observer = self.testScheduler.createObserver([BookmarksSection].self)
    viewModel.outputs.items
      .drive(observer)
      .disposed(by: self.disposeBag)
    self.testScheduler.start()

    let expectedEvents = [
      next(  0, [BookmarksSection(model: "", items: bookmarks)]),
      next(100, [BookmarksSection(model: "", items: [bookmarks[1], bookmarks[2], bookmarks[0]])]),
      next(200, [BookmarksSection(model: "", items: [bookmarks[2], bookmarks[1], bookmarks[0]])])
    ]
    self.assertEqual(observer.events, expectedEvents)
  }

  // MARK: - Delete

  func test_updatesItems_onItemDeleted() {
    let bookmarks = self.testData
    self.bookmarksManager.bookmarks = bookmarks
    let viewModel = BookmarksViewModel()

    let event0 = next(100, IndexPath(item: 1, section: 0)) // middle
    let event1 = next(200, IndexPath(item: 1, section: 0)) // last
    let event2 = next(300, IndexPath(item: 0, section: 0)) // first
    self.simulateDeleteEvents(in: viewModel, events: [event0, event1, event2])

    let observer = self.testScheduler.createObserver([BookmarksSection].self)
    viewModel.outputs.items
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
  }

  // MARK: - Save

  func test_saveItems_onMove() {
    let bookmarks = self.testData
    self.bookmarksManager.bookmarks = bookmarks
    let viewModel = BookmarksViewModel()

    let event = next(100, ItemMovedEvent(IndexPath(item: 0, section: 0), IndexPath(item: 2, section: 0)))
    self.simulateMoveEvents(in: viewModel, events: [event])

    self.testScheduler.start()

    let expectedBookmarks = [bookmarks[1], bookmarks[2], bookmarks[0]]
    XCTAssertEqual(self.bookmarksManager.bookmarks, expectedBookmarks)
  }

  func test_saveItems_onDelete() {
    let bookmarks = self.testData
    self.bookmarksManager.bookmarks = bookmarks
    let viewModel = BookmarksViewModel()

    let event = next(100, IndexPath(item: 1, section: 0)) // middle
    self.simulateDeleteEvents(in: viewModel, events: [event])

    self.testScheduler.start()

    let expectedBookmarks = [bookmarks[0], bookmarks[2]]
    XCTAssertEqual(self.bookmarksManager.bookmarks, expectedBookmarks)
  }

  // MARK: - IsVisible

  func test_showsPlaceholder_whenNoBookmarksSaved() {
    self.bookmarksManager.bookmarks = []
    let viewModel = BookmarksViewModel()

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

    let expectedTableViewEvents = self.oppositeVisibilityEvents(expectedPlaceholderEvents)
    XCTAssertEqual(tableViewObserver.events, expectedTableViewEvents)
  }

  func test_showsTableView_whenBookmarksSaved() {
    self.bookmarksManager.bookmarks = self.testData
    let viewModel = BookmarksViewModel()

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

    let expectedTableViewEvents = self.oppositeVisibilityEvents(expectedPlaceholderEvents)
    XCTAssertEqual(tableViewObserver.events, expectedTableViewEvents)
  }

  func test_showsPlaceholder_whenAllBookmarksDeleted() {
    self.bookmarksManager.bookmarks = self.testData
    let viewModel = BookmarksViewModel()

    let deleteTimes  = self.bookmarksManager.bookmarks.enumerated().map { TestTime($0.offset * 100 + 100) }
    let deleteEvents = deleteTimes.map { next($0, IndexPath(item: 0, section: 0)) }
    self.simulateDeleteEvents(in: viewModel, events: deleteEvents)

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

    let expectedTableViewEvents = self.oppositeVisibilityEvents(expectedPlaceholderEvents)
    XCTAssertEqual(tableViewObserver.events, expectedTableViewEvents)
  }

  // MARK: - Edit

  func test_isEditingChanges_onEditClick() {
    let viewModel = BookmarksViewModel()
    self.simulateEditClickEvents(in: viewModel, times: [100, 200])

    let observer = self.testScheduler.createObserver(Bool.self)
    viewModel.outputs.isEditing
      .drive(observer)
      .disposed(by: self.disposeBag)
    self.testScheduler.start()

    let expectedEvents = [next(0, false), next(100, true), next(200, false)]
    XCTAssertEqual(observer.events, expectedEvents)
  }

  func test_editButtonTextChanges_onEditClick() {
    let viewModel = BookmarksViewModel()
    self.simulateEditClickEvents(in: viewModel, times: [100, 200])

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

  // MARK: - Close

  func test_didClose_onViewDidDisappear() {
    let viewModel = BookmarksViewModel()
    self.simulateViewDidDisappearEvents(in: viewModel, times: [100, 200])

    let observer = self.testScheduler.createObserver(Void.self)
    viewModel.outputs.didClose
      .drive(observer)
      .disposed(by: self.disposeBag)
    self.testScheduler.start()

    let expectedEvents = [next(100, ()), next(200, ())]
    self.assertEqual(observer.events, expectedEvents)
  }
}
