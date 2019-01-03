// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import ReSwift
import RxSwift
import RxCocoa

private typealias TextStyles   = BookmarksCardConstants.TextStyles
private typealias Localization = Localizable.Bookmarks

public final class BookmarksCardViewModel {

  private let disposeBag = DisposeBag()

  // MARK: - Inputs

  public let didSelectItem: AnyObserver<Int>
  public let didMoveItem:   AnyObserver<(from: Int, to: Int)>
  public let didDeleteItem: AnyObserver<Int>

  public let didPressEditButton: AnyObserver<Void>

  // MARK: - Outputs

  public let bookmarks: Driver<[Bookmark]>

  public let isTableViewVisible:   Driver<Bool>
  public let isPlaceholderVisible: Driver<Bool>

  public let isEditing:      Driver<Bool>
  public let editButtonText: Driver<NSAttributedString>

  public let close: Driver<Void>

  // MARK: - Init

  // swiftlint:disable:next function_body_length
  public init(_ store: Store<AppState>) {
    let _didSelectItem = PublishSubject<Int>()
    self.didSelectItem = _didSelectItem.asObserver()

    let _didMoveItem = PublishSubject<(from: Int, to: Int)>()
    self.didMoveItem = _didMoveItem.asObserver()

    let _didDeleteItem = PublishSubject<Int>()
    self.didDeleteItem = _didDeleteItem.asObserver()

    let _didPressEditButton = PublishSubject<Void>()
    self.didPressEditButton = _didPressEditButton.asObserver()

    // bookmarks
    self.bookmarks = store.rx.state
      .map { $0.userData.bookmarks }
      .asDriver(onErrorDriveWith: .never())

    self.isTableViewVisible   = self.bookmarks.map { $0.any }
    self.isPlaceholderVisible = self.bookmarks.map { $0.isEmpty }

    // edit
    self.isEditing = _didPressEditButton
      .reducing(false) { current, _ in !current }
      .asDriver(onErrorDriveWith: .never())

    self.editButtonText = isEditing.map(createEditButtonLabel)

    // close
    self.close = _didSelectItem
      .map { _ in () }
      .asDriver(onErrorDriveWith: .never())

    // bindings
    _didSelectItem.asObservable()
      .withLatestFrom(self.bookmarks) { index, bookmarks in bookmarks[index] }
      .bind { store.dispatch(TrackedLinesAction.startTracking($0.lines)) }
      .disposed(by: self.disposeBag)

    _didMoveItem.asObservable()
      .bind { store.dispatch(BookmarksAction.move(from: $0.from, to: $0.to)) }
      .disposed(by: self.disposeBag)

    _didDeleteItem.asObservable()
      .bind { store.dispatch(BookmarksAction.remove(at: $0)) }
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
