//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

private typealias TextStyles   = BookmarksViewControllerConstants.TextStyles
private typealias Localization = Localizable.Bookmarks

protocol BookmarksViewModelInput {
  var editButtonPressed: AnyObserver<Void> { get }
}

protocol BookmarksViewModelOutput {
  var isEditing:      Driver<Bool> { get }
  var editButtonText: Driver<NSAttributedString> { get }
}

class BookmarksViewModel: BookmarksViewModelInput, BookmarksViewModelOutput {

  private let _isEditing         = BehaviorSubject(value: false)
  private let _editButtonPressed = PublishSubject<Void>()

  private let disposeBag = DisposeBag()

  // input
  var editButtonPressed: AnyObserver<Void> { return self._editButtonPressed.asObserver() }

  // output
  var isEditing:      Driver<Bool> { return self._isEditing.asDriver(onErrorDriveWith: .never()) }
  var editButtonText: Driver<NSAttributedString>

  init() {
    self._editButtonPressed.asObservable()
      .withLatestFrom(self._isEditing.asObservable())
      .map { !$0 }
      .bind(to: self._isEditing)
      .disposed(by: self.disposeBag)

    self.editButtonText = self._isEditing.asObservable()
      .map { createEditButtonLabel(isEditing: $0) }
      .asDriver(onErrorDriveWith: .never())
  }

  // MARK: - Input/Output

  var inputs:  BookmarksViewModelInput  { return self }
  var outputs: BookmarksViewModelOutput { return self }
}

// MARK: - Edit

private func createEditButtonLabel(isEditing: Bool) -> NSAttributedString {
  switch isEditing {
  case true:  return NSAttributedString(string: Localization.Edit.done, attributes: TextStyles.Edit.done)
  case false: return NSAttributedString(string: Localization.Edit.edit, attributes: TextStyles.Edit.edit)
  }
}
