//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

private typealias TextStyles   = BookmarksCardConstants.TextStyles
private typealias Localization = Localizable.Bookmarks

typealias BookmarksSection = RxSectionModel<String, Bookmark>

protocol BookmarksCardViewModelInput {
  var itemSelected: AnyObserver<IndexPath>      { get }
  var itemMoved:    AnyObserver<ItemMovedEvent> { get }
  var itemDeleted:  AnyObserver<IndexPath>      { get }

  var editButtonPressed: AnyObserver<Void> { get }
}

protocol BookmarksCardViewModelOutput {
  var bookmarks: Driver<[BookmarksSection]> { get }

  var isTableViewVisible:   Driver<Bool> { get }
  var isPlaceholderVisible: Driver<Bool> { get }

  var isEditing:      Driver<Bool>               { get }
  var editButtonText: Driver<NSAttributedString> { get }

  var shouldClose: Driver<Void> { get }
}

class BookmarksCardViewModel: BookmarksCardViewModelInput, BookmarksCardViewModelOutput {

  // MARK: - Properties

  private let _itemSelected      = PublishSubject<IndexPath>()
  private let _itemMoved         = PublishSubject<ItemMovedEvent>()
  private let _itemDeleted       = PublishSubject<IndexPath>()
  private let _editButtonPressed = PublishSubject<Void>()

  private let disposeBag = DisposeBag()

  // MARK: - Input

  lazy var itemSelected:      AnyObserver<IndexPath>      = self._itemSelected.asObserver()
  lazy var itemMoved:         AnyObserver<ItemMovedEvent> = self._itemMoved.asObserver()
  lazy var itemDeleted:       AnyObserver<IndexPath>      = self._itemDeleted.asObserver()
  lazy var editButtonPressed: AnyObserver<Void>           = self._editButtonPressed.asObserver()

  // MARK: - Output

  lazy var bookmarks: Driver<[BookmarksSection]> = {
    let defaultValue = BookmarksCardViewModel.getBookmarks()
    let moveOperation   = self._itemMoved.map   { RxCollectionOperation.move(from: $0.sourceIndex, to: $0.destinationIndex) }
    let deleteOperation = self._itemDeleted.map { RxCollectionOperation.delete(indexPath: $0) }

    return Observable.merge(moveOperation, deleteOperation)
      .reducing(defaultValue) { current, operation in current.apply(operation) }
      .asDriver(onErrorJustReturn: [])
  }()

  lazy var isTableViewVisible: Driver<Bool> = self.bookmarks
    .map { $0.hasItems() }
    .asDriver(onErrorDriveWith: .never())

  lazy var isPlaceholderVisible: Driver<Bool> = self.isTableViewVisible
    .not()

  lazy var isEditing: Driver<Bool> = {
    let defaultValue = false
    return self._editButtonPressed
      .reducing(defaultValue) { current, _ in !current }
      .asDriver(onErrorDriveWith: .never())
  }()

  lazy var editButtonText: Driver<NSAttributedString> = self.isEditing
    .map(createEditButtonLabel)

  lazy var shouldClose: Driver<Void> = self._itemSelected
    .map { _ in () }
    .asDriver(onErrorDriveWith: .never())

  // MARK: - Init

  init() {
    self.bookmarks
      .skip(1) // skip initial binding
      .drive(onNext: { BookmarksCardViewModel.saveBookmarks($0) })
      .disposed(by: self.disposeBag)

    self._itemSelected
      .withLatestFrom(self.bookmarks) { index, items in items[index] }
      .bind(onNext: { BookmarksCardViewModel.startTracking($0) })
      .disposed(by: self.disposeBag)
  }

  // MARK: - Managers

  private static func getBookmarks() -> [BookmarksSection] {
    let bookmarks = Managers.bookmarks.get()
    return [BookmarksSection(model: "", items: bookmarks)]
  }

  private static func saveBookmarks(_ sections: [BookmarksSection]) {
    let bookmarks = sections.flatMap { $0.items }
    Managers.bookmarks.save(bookmarks)
  }

  private static func startTracking(_ bookmark: Bookmark) {
    Managers.tracking.start(bookmark.lines)
  }

  // MARK: - Input/Output

  var inputs:  BookmarksCardViewModelInput  { return self }
  var outputs: BookmarksCardViewModelOutput { return self }
}

// MARK: - Edit

private func createEditButtonLabel(isEditing: Bool) -> NSAttributedString {
  switch isEditing {
  case true:  return NSAttributedString(string: Localization.Edit.done, attributes: TextStyles.Edit.done)
  case false: return NSAttributedString(string: Localization.Edit.edit, attributes: TextStyles.Edit.edit)
  }
}
