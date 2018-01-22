//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import Result
import RxSwift
import RxCocoa

protocol SearchCardViewModelInput {
  var pageSelected:      AnyObserver<LineType> { get }
  var pageDidTransition: AnyObserver<LineType> { get }

  var lineSelected:   AnyObserver<Line> { get }
  var lineDeselected: AnyObserver<Line> { get }

  var bookmarkButtonPressed: AnyObserver<Void> { get }
  var searchButtonPressed:   AnyObserver<Void> { get }

  var apiAlertTryAgainButtonPressed: AnyObserver<Void>    { get }
  var bookmarkAlertNameEntered:      AnyObserver<String> { get }

  var viewDidAppear:    AnyObserver<Void> { get }
  var viewDidDisappear: AnyObserver<Void> { get }
}

protocol SearchCardViewModelOutput {
  var page:          Driver<LineType> { get }
  var lines:         Driver<[Line]>   { get }
  var selectedLines: Driver<[Line]>   { get }

  var isLineSelectorVisible: Driver<Bool> { get }
  var isPlaceholderVisible:  Driver<Bool> { get }

  var showApiErrorAlert: Driver<SearchCardApiError>      { get }
  var showBookmarkAlert: Driver<SearchCardBookmarkAlert> { get }

  var shouldClose: Driver<Void> { get }
}

class SearchCardViewModel: SearchCardViewModelInput, SearchCardViewModelOutput {

  // MARK: - Properties

  private let _pageSelected          = PublishSubject<LineType>()
  private let _pageDidTransition     = PublishSubject<LineType>()
  private let _lineSelected          = PublishSubject<Line>()
  private let _lineDeselected        = PublishSubject<Line>()
  private let _bookmarkButtonPressed = PublishSubject<Void>()
  private let _searchButtonPressed   = PublishSubject<Void>()

  private let _apiAlertTryAgainButtonPressed = PublishSubject<Void>()
  private let _bookmarkAlertNameEntered      = PublishSubject<String>()

  private let _viewDidAppear    = PublishSubject<Void>()
  private let _viewDidDisappear = PublishSubject<Void>()

  private lazy var lineResponse: SearchCardApiResponse = {
    let viewDidAppear = self._viewDidAppear
    let tryAgain      = self._apiAlertTryAgainButtonPressed
      .delay(AppInfo.Timings.FailedRequestDelay.lines, scheduler: MainScheduler.instance)

    return Observable.merge(viewDidAppear, tryAgain)
      .flatMapLatest { _ in ApiManagerAdapter.getAvailableLines().catchError { _ in .empty() } }
      .map(toApiResponse)
      .share()
  }()

  private let disposeBag = DisposeBag()

  // MARK: - Input

  lazy var pageSelected:          AnyObserver<LineType> = self._pageSelected.asObserver()
  lazy var pageDidTransition:     AnyObserver<LineType> = self._pageDidTransition.asObserver()
  lazy var lineSelected:          AnyObserver<Line>     = self._lineSelected.asObserver()
  lazy var lineDeselected:        AnyObserver<Line>     = self._lineDeselected.asObserver()
  lazy var bookmarkButtonPressed: AnyObserver<Void>     = self._bookmarkButtonPressed.asObserver()
  lazy var searchButtonPressed:   AnyObserver<Void>     = self._searchButtonPressed.asObserver()

  lazy var apiAlertTryAgainButtonPressed: AnyObserver<Void>   = self._apiAlertTryAgainButtonPressed.asObserver()
  lazy var bookmarkAlertNameEntered:      AnyObserver<String> = self._bookmarkAlertNameEntered.asObserver()

  lazy var viewDidAppear:    AnyObserver<Void> = self._viewDidAppear.asObserver()
  lazy var viewDidDisappear: AnyObserver<Void> = self._viewDidDisappear.asObserver()

  // MARK: - Output

  let page:          Driver<LineType>
  let selectedLines: Driver<[Line]>

  lazy var lines: Driver<[Line]> = self.lineResponse
    .values()
    .startWith([])
    .asDriver(onErrorDriveWith: .never())

  lazy var isLineSelectorVisible: Driver<Bool> = self.lines.map { $0.any }
  lazy var isPlaceholderVisible:  Driver<Bool> = self.isLineSelectorVisible.not()

  lazy var showApiErrorAlert: Driver<SearchCardApiError> = self.lineResponse
    .errors()
    .asDriver(onErrorDriveWith: .never())

  lazy var showBookmarkAlert: Driver<SearchCardBookmarkAlert> = self._bookmarkButtonPressed
    .withLatestFrom(self.selectedLines)
    .map(toBookmarkAlert)
    .asDriver(onErrorDriveWith: .never())

  lazy var shouldClose: Driver<Void> = self._searchButtonPressed
    .map { _ in () }
    .asDriver(onErrorDriveWith: .never())

  // MARK: - Init

  init() {
    let state = Managers.search.getState()

    self.page = Observable.merge(self._pageSelected, self._pageDidTransition)
      .startWith(state.page)
      .asDriver(onErrorDriveWith: .never())

    let selectOperation   = self._lineSelected  .map { ArrayOperation.append(element: $0) }
    let deselectOperation = self._lineDeselected.map { ArrayOperation.remove(element: $0) }

    self.selectedLines = Observable.merge(selectOperation, deselectOperation)
      .reducing(state.selectedLines) { $0.apply($1) }
      .asDriver(onErrorDriveWith: .never())

    self.initOperations()
  }

  private func initOperations() {
    self._bookmarkAlertNameEntered
      .withLatestFrom(self.selectedLines) { (name: $0, lines: $1) }
      .map  { Bookmark(name: $0.name, lines: $0.lines) }
      .bind { Managers.bookmarks.add($0) }
      .disposed(by: self.disposeBag)

    self._searchButtonPressed
      .withLatestFrom(self.selectedLines) { $1 }
      .bind(onNext: { Managers.tracking.start($0) })
      .disposed(by: self.disposeBag)

    self._viewDidDisappear
      .withLatestFrom(self.page) { $1 }
      .withLatestFrom(self.selectedLines) { (page: $0, selectedLines: $1) }
      .map  { SearchCardState(page: $0.page, selectedLines: $0.selectedLines) }
      .bind { Managers.search.save($0) }
      .disposed(by: self.disposeBag)
  }

  // MARK: - Input/Output

  var inputs:  SearchCardViewModelInput  { return self }
  var outputs: SearchCardViewModelOutput { return self }
}

private func toApiResponse(_ response: Result<[Line], ApiError>) -> Result<[Line], SearchCardApiError> {
  switch response {
  case let .success(lines):
    switch lines.any {
    case true:  return .success(lines)
    case false: return .failure(.generalError)
    }
  case let .failure(apiError):
    switch apiError {
    case .noInternet:      return .failure(.noInternet)
    case .connectionError,
         .invalidResponse: return .failure(.generalError)
    }
  }
}

private func toBookmarkAlert(_ selectedLines: [Line]) -> SearchCardBookmarkAlert {
  switch selectedLines.any {
  case true:  return .nameInput
  case false: return .noLinesSelected
  }
}
