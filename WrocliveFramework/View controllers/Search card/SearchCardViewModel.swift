// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import ReSwift
import RxSwift
import RxCocoa

public final class SearchCardViewModel {

  private let disposeBag = DisposeBag()

  // MARK: - Inputs

  public let didPressBookmarkButton: AnyObserver<Void>
  public let didPressSearchButton:   AnyObserver<Void>

  public let didPressAlertTryAgainButton: AnyObserver<Void>
  public let didEnterBookmarkName:        AnyObserver<String>

  public let viewWillAppear: AnyObserver<Void>

  // MARK: - Output

  public let lineSelectorViewModel:     LineSelectorViewModel
  public let lineTypeSelectorViewModel: LineTypeSelectorViewModel

  public let isLineSelectorVisible: Driver<Bool>
  public let isPlaceholderVisible:  Driver<Bool>

  public let showAlert: Driver<SearchCardAlert>

  public let close: Driver<Void>

  // MARK: - Init

  // swiftlint:disable:next function_body_length
  public init(store: Store<AppState>) {
    let _didPressBookmarkButton = PublishSubject<Void>()
    self.didPressBookmarkButton = _didPressBookmarkButton.asObserver()

    let _didPressSearchButton = PublishSubject<Void>()
    self.didPressSearchButton = _didPressSearchButton.asObserver()

    let _didPressAlertTryAgainButton = PublishSubject<Void>()
    self.didPressAlertTryAgainButton = _didPressAlertTryAgainButton.asObserver()

    let _didEnterBookmarkName = PublishSubject<String>()
    self.didEnterBookmarkName = _didEnterBookmarkName.asObserver()

    let _viewWillAppear = PublishSubject<Void>()
    self.viewWillAppear = _viewWillAppear.asObserver()

    // common
    let page = store.rx.state
      .map { $0.userData.searchCardState.page }

    let linesResponse = store.rx.state
      .skipUntil(_viewWillAppear.asObservable()) // so that we don't see value from previous state
      .map { $0.apiData.lines }
      .share()

    let selectedLines = store.rx.state
      .map { $0.userData.searchCardState.selectedLines }

    // components
    self.lineTypeSelectorViewModel = LineTypeSelectorViewModel(
      pageProp:     page,
      onPageChange: dispatchSelectPageAction(store)
    )

    self.lineSelectorViewModel = LineSelectorViewModel(
      pageProp:          page,
      linesProp:         linesResponse.data(),
      selectedLinesProp: selectedLines,
      onPageTransition:  dispatchSelectPageAction(store),
      onLineSelected:    dispatchSelectLineAction(store),
      onLineDeselected:  dispatchDeselectLineAction(store)
    )

    // visibility
    self.isLineSelectorVisible = linesResponse
      .data()
      .map { $0.any }
      .startWith(false)
      .distinctUntilChanged()
      .asDriver(onErrorDriveWith: .never())

    self.isPlaceholderVisible = self.isLineSelectorVisible.map { !$0 }

    // alerts
    let apiErrorAlert = linesResponse
      .errors()
      .map(SearchCardAlert.apiError)

    let responseWithoutLinesAlert = linesResponse
      .data()
      .flatMapLatest { lines -> Driver<SearchCardAlert> in
        switch lines.any {
        case true: return .never()
        case false: return .just(SearchCardAlert.apiError(.generalError))
        }
      }

    let bookmarkAlert = _didPressBookmarkButton
      .withLatestFrom(selectedLines)
      .map { $0.any ? SearchCardAlert.bookmarkNameInput : SearchCardAlert.bookmarkNoLineSelected }

    self.showAlert = Observable.merge(apiErrorAlert, responseWithoutLinesAlert, bookmarkAlert)
      .distinctUntilChanged()
      .asDriver(onErrorDriveWith: .never())

    // close
    self.close = _didPressSearchButton
      .map { _ in () }
      .asDriver(onErrorDriveWith: .never())

    // bindings
    _didPressSearchButton
      .withLatestFrom(selectedLines)
      .bind { store.dispatch(TrackedLinesAction.startTracking($0)) }
      .disposed(by: self.disposeBag)

    _didEnterBookmarkName
      .withLatestFrom(selectedLines) { (name: $0, lines: $1) }
      .bind { store.dispatch(BookmarksAction.add(name: $0.name, lines: $0.lines)) }
      .disposed(by: self.disposeBag)

    Observable.merge(_viewWillAppear.asObservable(), _didPressAlertTryAgainButton)
      .bind { store.dispatch(ApiAction.updateLines) }
      .disposed(by: self.disposeBag)
  }
}

// MARK: - Dispatch

private func dispatchSelectPageAction(_ store: Store<AppState>) -> (LineType) -> () {
  return { store.dispatch(SearchCardStateAction.selectPage($0)) }
}

private func dispatchSelectLineAction(_ store: Store<AppState>) -> (Line) -> () {
  return { store.dispatch(SearchCardStateAction.selectLine($0)) }
}

private func dispatchDeselectLineAction(_ store: Store<AppState>) -> (Line) -> () {
  return { store.dispatch(SearchCardStateAction.deselectLine($0)) }
}
