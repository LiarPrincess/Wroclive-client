//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

private typealias TextStyles   = BookmarksViewControllerConstants.TextStyles
private typealias Localization = Localizable.Bookmarks

typealias BookmarksSection = RxSectionModel<String, Bookmark>

protocol BookmarksViewModelInput {
  var itemSelected: AnyObserver<IndexPath>      { get }
  var itemMoved:    AnyObserver<ItemMovedEvent> { get }
  var itemDeleted:  AnyObserver<IndexPath>      { get }

  var editButtonPressed: AnyObserver<Void> { get }
  var viewClosed:        AnyObserver<Void> { get }
}

protocol BookmarksViewModelOutput {
  var items:        Driver<[BookmarksSection]> { get }
  var selectedItem: Driver<Bookmark>          { get }

  var isTableViewVisible:   Driver<Bool> { get }
  var isPlaceholderVisible: Driver<Bool> { get }

  var isEditing:      Driver<Bool> { get }
  var editButtonText: Driver<NSAttributedString> { get }

  var didClose: Driver<Void> { get }
}

class BookmarksViewModel: BookmarksViewModelInput, BookmarksViewModelOutput {

  // MARK: - Properties

  private let _items:      Variable<[BookmarksSection]>
  private let _isEditing = Variable(false)

  private let _itemSelected = PublishSubject<IndexPath>()
  private let _itemMoved    = PublishSubject<ItemMovedEvent>()
  private let _itemDeleted  = PublishSubject<IndexPath>()

  private let _editButtonPressed = PublishSubject<Void>()
  private let _viewClosed        = PublishSubject<Void>()

  private let disposeBag = DisposeBag()

  // input
  lazy var itemSelected: AnyObserver<IndexPath>      = self._itemSelected.asObserver()
  lazy var itemMoved:    AnyObserver<ItemMovedEvent> = self._itemMoved.asObserver()
  lazy var itemDeleted:  AnyObserver<IndexPath>      = self._itemDeleted.asObserver()

  lazy var editButtonPressed: AnyObserver<Void> = self._editButtonPressed.asObserver()
  lazy var viewClosed:        AnyObserver<Void> = self._viewClosed.asObserver()

  // output
  let items:        Driver<[BookmarksSection]>
  let selectedItem: Driver<Bookmark>

  let isTableViewVisible:   Driver<Bool>
  let isPlaceholderVisible: Driver<Bool>

  let isEditing:      Driver<Bool>
  let editButtonText: Driver<NSAttributedString>

  let didClose: Driver<Void>

  // MARK: - Init

  init() {
    self._items = Variable(BookmarksViewModel.getBookmarks())
    self.items  = self._items.asDriver()

    self.selectedItem = self._itemSelected
      .withLatestFrom(self.items) { $1[$0] }
      .asDriver(onErrorDriveWith: .never())

    self.isTableViewVisible = self.items
      .map { any($0) }
      .asDriver(onErrorDriveWith: .never())

    self.isPlaceholderVisible = self.items
      .map { isEmpty($0) }
      .asDriver(onErrorDriveWith: .never())

    self.isEditing = self._isEditing
      .asDriver()

    self.editButtonText = self._isEditing
      .asDriver()
      .map { createEditButtonLabel(isEditing: $0) }

    self.didClose = self._viewClosed.asDriver(onErrorDriveWith: .never())

    self.bindInputs()
  }

  private func bindInputs() {
    self._itemMoved
      .bind { [weak self] in self?._items.value.move(from: $0.sourceIndex, to: $0.destinationIndex) }
      .disposed(by: self.disposeBag)

    self._itemDeleted
      .bind { [weak self] in self?._items.value.remove(at: $0) }
      .disposed(by: self.disposeBag)

    let didMoveItem   = self._itemMoved.map   { _ in () }
    let didDeleteItem = self._itemDeleted.map { _ in () }
    Observable.merge(didMoveItem, didDeleteItem)
      .withLatestFrom(self.items)
      .bind { BookmarksViewModel.saveBookmarks($0) }
      .disposed(by: self.disposeBag)

    // swiftlint:disable:next array_init
    self._editButtonPressed
      .withLatestFrom(self.isEditing)
      .map { !$0 }
      .bind(to: self._isEditing)
      .disposed(by: self.disposeBag)
  }

  // MARK: - Bookmarks

  private static func getBookmarks() -> [BookmarksSection] {
    let bookmarks = Managers.bookmarks.getAll()
    return [BookmarksSection(model: "", items: bookmarks)]
  }

  private static func saveBookmarks(_ sections: [BookmarksSection]) {
    let bookmarks = sections.flatMap { $0.items }
    Managers.bookmarks.save(bookmarks)
  }

  // MARK: - Input/Output

  var inputs:  BookmarksViewModelInput  { return self }
  var outputs: BookmarksViewModelOutput { return self }
}

// MARK: - Items

private func any(_ sections: [BookmarksSection]) -> Bool {
  return !isEmpty(sections)
}

private func isEmpty(_ sections: [BookmarksSection]) -> Bool {
  let firstNotEmpty = sections.first { $0.items.any }
  return firstNotEmpty == nil
}

// MARK: - Edit

private func createEditButtonLabel(isEditing: Bool) -> NSAttributedString {
  switch isEditing {
  case true:  return NSAttributedString(string: Localization.Edit.done, attributes: TextStyles.Edit.done)
  case false: return NSAttributedString(string: Localization.Edit.edit, attributes: TextStyles.Edit.edit)
  }
}
