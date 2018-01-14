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

  var linesSelected: AnyObserver<[Line]> { get }

  var bookmarkButtonPressed: AnyObserver<Void> { get }
  var searchButtonPressed:   AnyObserver<Void> { get }

  var apiAlertTryAgainButtonPressed: AnyObserver<Void>    { get }
  var bookmarkAlertNameEntered:      AnyObserver<String?> { get }

  var viewDidAppear:    AnyObserver<Void> { get }
  var viewDidDisappear: AnyObserver<Void> { get }
}

protocol SearchCardViewModelOutput {
  var page:  Driver<LineType>        { get }
  var lines: Driver<SearchCardLines> { get }

  var isLineSelectorVisible: Driver<Bool> { get }
  var isPlaceholderVisible:  Driver<Bool> { get }

  var showApiErrorAlert: Driver<SearchCardApiAlert>      { get }
  var showBookmarkAlert: Driver<SearchCardBookmarkAlert> { get }

  var shouldClose: Driver<Void> { get }
}

class SearchCardViewModel: SearchCardViewModelInput, SearchCardViewModelOutput {

  // MARK: - Properties

  private let _pageSelected          = PublishSubject<LineType>()
  private let _pageDidTransition     = PublishSubject<LineType>()
  private let _linesSelected         = PublishSubject<[Line]>()
  private let _bookmarkButtonPressed = PublishSubject<Void>()
  private let _searchButtonPressed   = PublishSubject<Void>()

  private let _apiAlertTryAgainButtonPressed = PublishSubject<Void>()
  private let _bookmarkAlertNameEntered      = PublishSubject<String?>()

  private let _viewDidAppear    = PublishSubject<Void>()
  private let _viewDidDisappear = PublishSubject<Void>()

  private lazy var lineResponse: ApiResponse<[Line]> = {
    let viewDidAppear = self._viewDidAppear
    let tryAgain      = self._apiAlertTryAgainButtonPressed
      .delay(AppInfo.Timings.FailedRequestDelay.lines, scheduler: MainScheduler.instance)

    return Observable.merge(viewDidAppear, tryAgain)
      .flatMap { _ in SearchCardNetworkAdapter.getAvailableLines().catchError { _ in .empty() } }
      .share()
  }()

  private let disposeBag = DisposeBag()

  // MARK: - Input

  lazy var pageSelected:          AnyObserver<LineType> = self._pageSelected.asObserver()
  lazy var pageDidTransition:     AnyObserver<LineType> = self._pageDidTransition.asObserver()
  lazy var linesSelected:         AnyObserver<[Line]>   = self._linesSelected.asObserver()
  lazy var bookmarkButtonPressed: AnyObserver<Void>     = self._bookmarkButtonPressed.asObserver()
  lazy var searchButtonPressed:   AnyObserver<Void>     = self._searchButtonPressed.asObserver()

  lazy var apiAlertTryAgainButtonPressed: AnyObserver<Void>    = self._apiAlertTryAgainButtonPressed.asObserver()
  lazy var bookmarkAlertNameEntered:      AnyObserver<String?> = self._bookmarkAlertNameEntered.asObserver()

  lazy var viewDidAppear:    AnyObserver<Void> = self._viewDidAppear.asObserver()
  lazy var viewDidDisappear: AnyObserver<Void> = self._viewDidDisappear.asObserver()

  // MARK: - Output

  let page:          Driver<LineType>
  let selectedLines: Driver<[Line]>

  lazy var lines: Driver<SearchCardLines> = self.lineResponse
    .values()
    .withLatestFrom(self.selectedLines) { SearchCardLines(lines: $0, selectedLines: $1) }
    .startWith(SearchCardLines(lines: [], selectedLines: []))
    .asDriver(onErrorDriveWith: .never())

  lazy var isLineSelectorVisible: Driver<Bool> = self.lines.map { $0.lines.any }
  lazy var isPlaceholderVisible:  Driver<Bool> = self.isLineSelectorVisible.not()

  lazy var showApiErrorAlert: Driver<SearchCardApiAlert> = self.lineResponse
    .errors()
    .map(toApiAlert)
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
      .startWith(state.selectedLineType)
      .asDriver(onErrorDriveWith: .never())

    self.selectedLines = self._linesSelected
      .startWith(state.selectedLines)
      .asDriver(onErrorDriveWith: .never())

    self._bookmarkAlertNameEntered
      .flatMap { Observable.from(optional: $0) }
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
      .withLatestFrom(self.selectedLines) { (lineType: $0, lines: $1) }
      .map { SearchState(withSelected: $0.lineType, lines: $0.lines) }
      .bind { Managers.search.save($0) }
      .disposed(by: self.disposeBag)
  }

  // MARK: - Managers

  private static func getSavedState() -> SearchState {
    return Managers.search.getState()
  }

  // MARK: - Input/Output

  var inputs:  SearchCardViewModelInput  { return self }
  var outputs: SearchCardViewModelOutput { return self }
}

private func toApiAlert(_ error: ApiError) -> SearchCardApiAlert {
  switch error {
  case .noInternet:                        return .noInternet
  case .connectionError, .invalidResponse: return .connectionError
  }
}

private func toBookmarkAlert(_ selectedLines: [Line]) -> SearchCardBookmarkAlert {
  switch selectedLines.any {
  case true:  return .nameInput
  case false: return .noLineSelcted
  }
}
