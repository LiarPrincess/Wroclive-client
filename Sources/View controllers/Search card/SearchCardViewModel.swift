// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import ReSwift
import RxSwift
import RxCocoa

class SearchCardViewModel {

  private let disposeBag = DisposeBag()

  // MARK: - Inputs

  let didSelectPage:       AnyObserver<LineType>
  let didTransitionToPage: AnyObserver<LineType>

  let didSelectLine:   AnyObserver<Line>
  let didDeselectLine: AnyObserver<Line>

  let didPressBookmarkButton: AnyObserver<Void>
  let didPressSearchButton:   AnyObserver<Void>

  let didPressAlertTryAgainButton: AnyObserver<Void>
  let didEnterBookmarkName:        AnyObserver<String>

  let viewDidAppear: AnyObserver<Void>

  // MARK: - Output

  let page: Driver<LineType>

  let lines:         Driver<[Line]>
  let selectedLines: Driver<[Line]>

  let isLineSelectorVisible: Driver<Bool>
  let isPlaceholderVisible:  Driver<Bool>

  let showAlert: Driver<SearchCardAlert>

  let close: Driver<Void>

  // MARK: - Init

  // swiftlint:disable:next function_body_length
  init(_ store: Store<AppState>) {
    let _didSelectPage = PublishSubject<LineType>()
    self.didSelectPage = _didSelectPage.asObserver()

    let _didTransitionToPage = PublishSubject<LineType>()
    self.didTransitionToPage = _didTransitionToPage.asObserver()

    let _didSelectLine = PublishSubject<Line>()
    self.didSelectLine = _didSelectLine.asObserver()

    let _didDeselectLine = PublishSubject<Line>()
    self.didDeselectLine = _didDeselectLine.asObserver()

    let _didPressBookmarkButton = PublishSubject<Void>()
    self.didPressBookmarkButton = _didPressBookmarkButton.asObserver()

    let _didPressSearchButton = PublishSubject<Void>()
    self.didPressSearchButton = _didPressSearchButton.asObserver()

    let _didPressAlertTryAgainButton = PublishSubject<Void>()
    self.didPressAlertTryAgainButton = _didPressAlertTryAgainButton.asObserver()

    let _didEnterBookmarkName = PublishSubject<String>()
    self.didEnterBookmarkName = _didEnterBookmarkName.asObserver()

    let _viewDidAppear = PublishSubject<Void>()
    self.viewDidAppear = _viewDidAppear.asObserver()

    // page
    self.page = store.rx.state
      .map { $0.userData.searchCardState.page }
      .asDriver(onErrorDriveWith: .never())

    // lines
    let lineResponses = Observable.merge(_viewDidAppear, _didPressAlertTryAgainButton)
      .flatMapLatest { _ in
        AppEnvironment.api.availableLines
          .map(noLinesToError)
          // basically materialize:
          .map { lines in Event.next(lines) }
          .catchError { error in Single.just(Event.error(error)) }
      }
      .share()

    self.lines = lineResponses.elements()
      .startWith([])
      .asDriver(onErrorDriveWith: .never())

    self.selectedLines = store.rx.state
      .map { $0.userData.searchCardState.selectedLines }
      .asDriver(onErrorDriveWith: .never())

    self.isLineSelectorVisible = self.lines.map { $0.any }
    self.isPlaceholderVisible  = self.lines.map { $0.isEmpty }

    // alerts
    let showApiErrorAlert = lineResponses.errors()
      .map(toApiErrorAlert)

    let showBookmarkAlert = _didPressBookmarkButton
      .withLatestFrom(self.selectedLines)
      .map(toBookmarkAlert)

    self.showAlert = Observable.merge(showApiErrorAlert, showBookmarkAlert)
      .asDriver(onErrorDriveWith: .never())

    // close
    self.close = _didPressSearchButton
      .map { _ in () }
      .asDriver(onErrorDriveWith: .never())

    // bindings
    Observable.merge(_didSelectPage, _didTransitionToPage)
      .bind { store.dispatch(SearchCardStateActions.selectPage($0)) }
      .disposed(by: self.disposeBag)

    _didSelectLine
      .bind { store.dispatch(SearchCardStateActions.selectLine($0)) }
      .disposed(by: self.disposeBag)

    _didDeselectLine
      .bind { store.dispatch(SearchCardStateActions.deselectLine($0)) }
      .disposed(by: self.disposeBag)

    _didPressSearchButton
      .withLatestFrom(self.selectedLines)
      .bind { store.dispatch(FutureActions.startTracking($0)) }
      .disposed(by: self.disposeBag)

    _didEnterBookmarkName
      .withLatestFrom(self.selectedLines) { (name: $0, lines: $1) }
      .bind { store.dispatch(BookmarksAction.add(name: $0.name, lines: $0.lines)) }
      .disposed(by: self.disposeBag)
  }
}

private func noLinesToError(_ lines: [Line]) throws -> [Line] {
  if lines.isEmpty {
    throw ApiError.generalError
  }

  return lines
}

private func toApiErrorAlert(_ error: Error) -> SearchCardAlert {
  let apiError = error as? ApiError ?? .generalError
  return .apiError(apiError)
}

private func toBookmarkAlert(_ selectedLines: [Line]) -> SearchCardAlert {
  switch selectedLines.any {
  case true:  return .bookmarkNameInput
  case false: return .bookmarkNoLineSelected
  }
}
