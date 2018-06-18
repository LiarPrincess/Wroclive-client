//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

private typealias TextStyles   = BookmarksCardConstants.TextStyles
private typealias Localization = Localizable.Bookmarks

class BookmarksCardViewModel {

  let disposeBag = DisposeBag()

  // MARK: - Inputs

  let didSelectItem: AnyObserver<Int>
  let didMoveItem:   AnyObserver<(from: Int, to: Int)>
  let didDeleteItem: AnyObserver<Int>

  let didPressEditButton: AnyObserver<Void>

  // MARK: - Outputs

  let bookmarks: Driver<[Bookmark]>

  let isTableViewVisible:   Driver<Bool>
  let isPlaceholderVisible: Driver<Bool>

  let isEditing:      Driver<Bool>
  let editButtonText: Driver<NSAttributedString>

  let startTracking: Driver<Bookmark>

  // MARK: - Init

  init() {
    let _didSelectItem = PublishSubject<Int>()
    self.didSelectItem = _didSelectItem.asObserver()

    let _didMoveItem = PublishSubject<(from: Int, to: Int)>()
    self.didMoveItem = _didMoveItem.asObserver()

    let _didDeleteItem = PublishSubject<Int>()
    self.didDeleteItem = _didDeleteItem.asObserver()

    let _didPressEditButton = PublishSubject<Void>()
    self.didPressEditButton = _didPressEditButton.asObserver()

    // bookmarks
    let moveOperation   = _didMoveItem.map   { Operation.move(from: $0.from, to: $0.to) }
    let removeOperation = _didDeleteItem.map { Operation.remove(index: $0) }

    self.bookmarks = Observable.merge(moveOperation, removeOperation)
      .reducing(AppEnvironment.storage.bookmarks, apply: apply)
      .asDriver(onErrorJustReturn: [])

    self.isTableViewVisible   = self.bookmarks.map { $0.any }
    self.isPlaceholderVisible = self.bookmarks.map { $0.isEmpty }

    // edit
    let isEditing = _didPressEditButton
      .reducing(false) { current, _ in !current }
      .asDriver(onErrorDriveWith: .never())

    self.isEditing      = isEditing
    self.editButtonText = isEditing.map(createEditButtonLabel)

    // selected bookmark
    self.startTracking = _didSelectItem
      .withLatestFrom(self.bookmarks) { index, bookmarks in bookmarks[index] }
      .asDriver(onErrorDriveWith: .never())

    self.initBindings()
  }

  private func initBindings() {
    self.bookmarks
      .skip(1) // skip initial binding
      .drive(onNext: { AppEnvironment.storage.saveBookmarks($0) })
      .disposed(by: self.disposeBag)
  }
}

// MARK: - Helpers

private func createEditButtonLabel(isEditing: Bool) -> NSAttributedString {
  switch isEditing {
  case true:  return NSAttributedString(string: Localization.Edit.done, attributes: TextStyles.Edit.done)
  case false: return NSAttributedString(string: Localization.Edit.edit, attributes: TextStyles.Edit.edit)
  }
}

private enum Operation {
  case move(from: Int, to: Int)
  case remove(index: Int)
}

private func apply(_ bookmarks: [Bookmark], _ operation: Operation) -> [Bookmark] {
  var copy = bookmarks
  switch operation {
  case let .move(from, to):
    let bookmark = copy.remove(at: from)
    copy.insert(bookmark, at: to)
  case let .remove(index):
    copy.remove(at: index)
  }
  return copy
}
