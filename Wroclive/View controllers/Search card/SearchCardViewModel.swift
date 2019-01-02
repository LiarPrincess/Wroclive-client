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
    let _linesResponse = store.rx.state
      .map { $0.apiData.lines }
      .asDriver(onErrorDriveWith: .never())

    self.lines = _linesResponse.data()

    self.selectedLines = store.rx.state
      .map { $0.userData.searchCardState.selectedLines }
      .asDriver(onErrorDriveWith: .never())

    self.isLineSelectorVisible = _linesResponse
      .flatMapLatest { response in
        switch response {
        case .data: return Driver.just(true)
        case .none, .inProgress: return Driver.just(false)
        case .error: return Driver.never() // on error just don't change visibility
        }
      }

    self.isPlaceholderVisible = self.isLineSelectorVisible.map { !$0 }

    // alerts

    let showApiErrorAlert = _linesResponse
      .errors()
      .map { SearchCardAlert.apiError($0 as? ApiError ?? .generalError) }

    let showBookmarkAlert = _didPressBookmarkButton
      .withLatestFrom(self.selectedLines)
      .map { $0.any ? SearchCardAlert.bookmarkNameInput : SearchCardAlert.bookmarkNoLineSelected }
      .asDriver(onErrorDriveWith: .never())

    self.showAlert = Driver.merge(showApiErrorAlert, showBookmarkAlert)

    // close
    self.close = _didPressSearchButton
      .map { _ in () }
      .asDriver(onErrorDriveWith: .never())

    // bindings
    Observable.merge(_didSelectPage, _didTransitionToPage)
      .bind { store.dispatch(SearchCardStateAction.selectPage($0)) }
      .disposed(by: self.disposeBag)

    _didSelectLine
      .bind { store.dispatch(SearchCardStateAction.selectLine($0)) }
      .disposed(by: self.disposeBag)

    _didDeselectLine
      .bind { store.dispatch(SearchCardStateAction.deselectLine($0)) }
      .disposed(by: self.disposeBag)

    _didPressSearchButton
      .withLatestFrom(self.selectedLines)
      .bind { store.dispatch(TrackedLinesAction.startTracking($0)) }
      .disposed(by: self.disposeBag)

    _didEnterBookmarkName
      .withLatestFrom(self.selectedLines) { (name: $0, lines: $1) }
      .bind { store.dispatch(BookmarksAction.add(name: $0.name, lines: $0.lines)) }
      .disposed(by: self.disposeBag)

    // update lines as soon as we open search card
    let updateLinesBeforeOpeningCard = Observable.just(())
    Observable.merge(updateLinesBeforeOpeningCard, _didPressAlertTryAgainButton)
      .bind { store.dispatch(ApiAction.updateLines) }
      .disposed(by: self.disposeBag)
  }
}
