//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import Result
import RxSwift
import RxCocoa

class SearchCardViewModel {

  let disposeBag = DisposeBag()

  // MARK: - Inputs

  let didSelectPage:       AnyObserver<LineType>
  let didTransitionToPage: AnyObserver<LineType>

  let didSelectLine:   AnyObserver<Line>
  let didDeselectLine: AnyObserver<Line>

  let didPressBookmarkButton: AnyObserver<Void>
  let didPressSearchButton:   AnyObserver<Void>

  let didPressAlertTryAgainButton: AnyObserver<Void>
  let didEnterBookmarkName:        AnyObserver<String>

  let viewDidAppear:    AnyObserver<Void>
  let viewDidDisappear: AnyObserver<Void>

  // MARK: - Output

  let page: Driver<LineType>

  let lines:         Driver<[Line]>
  let selectedLines: Driver<[Line]>

  let isLineSelectorVisible: Driver<Bool>
  let isPlaceholderVisible:  Driver<Bool>

  let showAlert: Driver<SearchCardAlert>

  let startTracking: Driver<[Line]>

  // MARK: - Init

  // swiftlint:disable:next function_body_length
  init() {
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

    let _viewDidDisappear = PublishSubject<Void>()
    self.viewDidDisappear = _viewDidDisappear.asObserver()

    let state = AppEnvironment.storage.searchCardState

    // page
    self.page = Observable.merge(_didSelectPage, _didTransitionToPage)
      .startWith(state.page)
      .asDriver(onErrorDriveWith: .never())

    // lines
    let tryAgainScheduler = AppEnvironment.schedulers.main
    let tryAgainDelay     = AppEnvironment.variables.timings.failedRequestDelay.lines
    let tryAgain          = _didPressAlertTryAgainButton.delay(tryAgainDelay, scheduler: tryAgainScheduler)

    let lineResponse = Observable.merge(_viewDidAppear, tryAgain)
      .flatMapLatest { _ in AppEnvironment.api.availableLines.catchError { _ in .empty() } }
      .map(emptyResponseAsError)
      .share()

    self.lines = lineResponse
      .values()
      .startWith([])
      .asDriver(onErrorDriveWith: .never())

    let selectOperation   = _didSelectLine.map   { Operation.append(line: $0) }
    let deselectOperation = _didDeselectLine.map { Operation.remove(line: $0) }

    self.selectedLines = Observable.merge(selectOperation, deselectOperation)
      .reducing(state.selectedLines, apply: apply)
      .asDriver(onErrorDriveWith: .never())

    self.isLineSelectorVisible = self.lines.map { $0.any }
    self.isPlaceholderVisible  = self.lines.map { $0.isEmpty }

    // alerts
    let showApiErrorAlert = lineResponse
      .errors()
      .map { SearchCardAlert.apiError(error: $0) }

    let showBookmarkAlert = _didPressBookmarkButton
      .withLatestFrom(self.selectedLines)
      .map(toBookmarkAlert)

    self.showAlert = Observable.merge(showApiErrorAlert, showBookmarkAlert)
      .asDriver(onErrorDriveWith: .never())

    // tracking
    self.startTracking = _didPressSearchButton
      .withLatestFrom(self.selectedLines)
      .asDriver(onErrorJustReturn: [])

    self.initBindings(_didEnterBookmarkName, _viewDidDisappear)
  }

  private func initBindings(_ didEnterBookmarkName: Observable<String>, _ viewDidDisappear: Observable<Void>) {
    didEnterBookmarkName
      .withLatestFrom(self.selectedLines) { Bookmark(name: $0, lines: $1) }
      .bind { AppEnvironment.storage.addBookmark($0) }
      .disposed(by: self.disposeBag)

    viewDidDisappear
      .withLatestFrom(self.page) { $1 }
      .withLatestFrom(self.selectedLines) { (page: $0, selectedLines: $1) }
      .map  { SearchCardState(page: $0.page, selectedLines: $0.selectedLines) }
      .bind { AppEnvironment.storage.saveSearchCardState($0) }
      .disposed(by: self.disposeBag)
  }
}

private func emptyResponseAsError(_ response: Result<[Line], ApiError>) -> Result<[Line], ApiError> {
  switch response {
  case let .success(lines):
    switch lines.any {
    case true:  return .success(lines)
    case false: return .failure(.generalError)
    }
  case .failure: return response
  }
}

private func toBookmarkAlert(_ selectedLines: [Line]) -> SearchCardAlert {
  switch selectedLines.any {
  case true:  return .bookmarkNameInput
  case false: return .bookmarkNoLineSelected
  }
}

private enum Operation {
  case append(line: Line)
  case remove(line: Line)
}

private func apply(_ lines: [Line], _ operation: Operation) -> [Line] {
  switch operation {
  case let .append(line):
    var copy = lines
    copy.append(line)
    return copy
  case let .remove(line):
    return lines.filter { $0 != line }
  }
}
