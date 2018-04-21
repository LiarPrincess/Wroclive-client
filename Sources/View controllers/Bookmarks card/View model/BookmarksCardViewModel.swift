//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

private typealias TextStyles   = BookmarksCardConstants.TextStyles
private typealias Localization = Localizable.Bookmarks

protocol BookmarksCardViewModelType {
  var inputs:  BookmarksCardViewModelInput  { get }
  var outputs: BookmarksCardViewModelOutput { get }
}

class BookmarksCardViewModel: BookmarksCardViewModelType, BookmarksCardViewModelInput, BookmarksCardViewModelOutput {

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
    let defaultValue    = [BookmarksSection(model: "", items: AppEnvironment.storage.bookmarks)]
    let moveOperation   = self._itemMoved.map   { RxSectionOperation.move(from: $0.sourceIndex, to: $0.destinationIndex) }
    let deleteOperation = self._itemDeleted.map { RxSectionOperation.remove(indexPath: $0) }

    return Observable.merge(moveOperation, deleteOperation)
      .reducing(defaultValue) { current, operation in current.apply(operation) }
      .asDriver(onErrorJustReturn: [])
  }()

  lazy var isTableViewVisible:   Driver<Bool> = self.bookmarks.map { $0.hasItems() }
  lazy var isPlaceholderVisible: Driver<Bool> = self.isTableViewVisible.not()

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
      .map(toBookmarks)
      .drive(onNext: { AppEnvironment.storage.saveBookmarks($0) })
      .disposed(by: self.disposeBag)

    self._itemSelected
      .withLatestFrom(self.bookmarks) { index, items in items[index] }
      .bind(onNext: { AppEnvironment.live.startTracking($0.lines) })
      .disposed(by: self.disposeBag)
  }

  // MARK: - Input/Output

  var inputs:  BookmarksCardViewModelInput  { return self }
  var outputs: BookmarksCardViewModelOutput { return self }
}

// MARK: - Helpers

private func createEditButtonLabel(isEditing: Bool) -> NSAttributedString {
  switch isEditing {
  case true:  return NSAttributedString(string: Localization.Edit.done, attributes: TextStyles.Edit.done)
  case false: return NSAttributedString(string: Localization.Edit.edit, attributes: TextStyles.Edit.edit)
  }
}

private func toBookmarks(_ sections: [BookmarksSection]) -> [Bookmark] {
  return sections.flatMap { $0.items }
}
