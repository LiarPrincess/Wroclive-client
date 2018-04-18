//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import Result
import RxSwift
import RxCocoa

protocol SearchCardViewModelType {
  var inputs:  SearchCardViewModelInput  { get }
  var outputs: SearchCardViewModelOutput { get }
}

class SearchCardViewModel: SearchCardViewModelType, SearchCardViewModelInput, SearchCardViewModelOutput {

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

  private lazy var lineResponse: ApiResponse<[Line]> = {
    let viewDidAppear = self._viewDidAppear
    let tryAgain      = self._apiAlertTryAgainButtonPressed
      .delay(AppInfo.Timings.FailedRequestDelay.lines, scheduler: MainScheduler.instance)

    return Observable.merge(viewDidAppear, tryAgain)
      .flatMapLatest { _ in Managers.api.availableLines.catchError { _ in .empty() } }
      .map(emptyResponseAsError)
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

  lazy var showApiErrorAlert: Driver<ApiError> = self.lineResponse
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
      .bind(onNext: { Managers.live.startTracking($0) })
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

private func toBookmarkAlert(_ selectedLines: [Line]) -> SearchCardBookmarkAlert {
  switch selectedLines.any {
  case true:  return .nameInput
  case false: return .noLinesSelected
  }
}
