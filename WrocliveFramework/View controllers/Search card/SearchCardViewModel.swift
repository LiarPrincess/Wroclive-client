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

  public let viewDidLoad: AnyObserver<Void>

  // MARK: - Output

  public let lineTypeSelectorViewModel: LineTypeSelectorViewModel
  public let lineSelectorViewModel:     LineSelectorViewModel

  public let isLineSelectorVisible: Driver<Bool>
  public let isPlaceholderVisible:  Driver<Bool>

  public let showAlert: Driver<SearchCardAlert>

  public let close: Driver<Void>

  // MARK: - Init

  // swiftlint:disable:next function_body_length
  public init(_ store: Store<AppState>) {
    self.lineTypeSelectorViewModel = LineTypeSelectorViewModel(store)
    self.lineSelectorViewModel     = LineSelectorViewModel(store)

    let _didPressBookmarkButton = PublishSubject<Void>()
    self.didPressBookmarkButton = _didPressBookmarkButton.asObserver()

    let _didPressSearchButton = PublishSubject<Void>()
    self.didPressSearchButton = _didPressSearchButton.asObserver()

    let _didPressAlertTryAgainButton = PublishSubject<Void>()
    self.didPressAlertTryAgainButton = _didPressAlertTryAgainButton.asObserver()

    let _didEnterBookmarkName = PublishSubject<String>()
    self.didEnterBookmarkName = _didEnterBookmarkName.asObserver()

    let _viewDidLoad = PublishSubject<Void>()
    self.viewDidLoad = _viewDidLoad.asObserver()

    let selectedLines = store.rx.state
      .map { $0.userData.searchCardState.selectedLines }

    // visibility
    let linesResponse = store.rx.state
      .map { $0.apiData.lines }
      .asDriver(onErrorDriveWith: .never())

    self.isLineSelectorVisible = _viewDidLoad.asObservable()
      .flatMapFirst { _ in linesResponse }
      .data()
      .map { $0.any }
      .startWith(false)
      .distinctUntilChanged()
      .asDriver(onErrorDriveWith: .never())

    self.isPlaceholderVisible = self.isLineSelectorVisible.map { !$0 }

    // alerts
    let showApiErrorAlert = linesResponse
      .errors()
      .map(SearchCardAlert.apiError)

    let responseWithoutLinesAlert = linesResponse.data()
      .flatMapLatest { lines -> Driver<SearchCardAlert> in
        switch lines.any {
        case true: return .never()
        case false: return .just(SearchCardAlert.apiError(.generalError))
        }
      }

    let showBookmarkAlert = _didPressBookmarkButton
      .withLatestFrom(selectedLines)
      .map { $0.any ? SearchCardAlert.bookmarkNameInput : SearchCardAlert.bookmarkNoLineSelected }
      .asDriver(onErrorDriveWith: .never())

    self.showAlert = Driver.merge(showApiErrorAlert, responseWithoutLinesAlert, showBookmarkAlert)
      .distinctUntilChanged()

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

    Observable.merge(_viewDidLoad.asObservable(), _didPressAlertTryAgainButton)
      .bind { store.dispatch(ApiAction.updateLines) }
      .disposed(by: self.disposeBag)
  }
}
