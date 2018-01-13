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

  var bookmarkButtonPressed: AnyObserver<Void> { get }
  var searchButtonPressed:   AnyObserver<Void> { get }

  var apiAlertTryAgainButtonPressed: AnyObserver<Void> { get }

  var viewDidAppear:    AnyObserver<Void> { get }
  var viewDidDisappear: AnyObserver<Void> { get }
}

protocol SearchCardViewModelOutput {
  var page: Driver<LineType> { get }

  var lines: Driver<[Line]> { get }

  var isLineSelectorVisible: Driver<Bool> { get }
  var isPlaceholderVisible:  Driver<Bool> { get }

  var showApiErrorAlert: Driver<SearchCardApiAlert> { get }

  var close: Driver<Void> { get }
}

class SearchCardViewModel: SearchCardViewModelInput, SearchCardViewModelOutput {

  // MARK: - Properties

  private let _pageSelected          = PublishSubject<LineType>()
  private let _pageDidTransition     = PublishSubject<LineType>()
  private let _bookmarkButtonPressed = PublishSubject<Void>()
  private let _searchButtonPressed   = PublishSubject<Void>()

  private let _apiAlertTryAgainButtonPressed = PublishSubject<Void>()

  private let _viewDidAppear    = PublishSubject<Void>()
  private let _viewDidDisappear = PublishSubject<Void>()

  private lazy var lineResponse: ApiResponse<[Line]> = {
    let viewDidAppear = self._viewDidAppear
    let tryAgain      = self._apiAlertTryAgainButtonPressed
      .delay(AppInfo.Timings.FailedRequestDelay.lines, scheduler: MainScheduler.instance)

    return Observable.merge(viewDidAppear, tryAgain)
      .flatMap { _ in SearchCardNetworkAdapter.getAvailableLines().catchError { _ in .empty() } }
      .startWith(.success([]))
      .share()
  }()

  private let disposeBag = DisposeBag()

  // MARK: - Input

  lazy var pageSelected:          AnyObserver<LineType> = self._pageSelected.asObserver()
  lazy var pageDidTransition:     AnyObserver<LineType> = self._pageDidTransition.asObserver()
  lazy var bookmarkButtonPressed: AnyObserver<Void>     = self._bookmarkButtonPressed.asObserver()
  lazy var searchButtonPressed:   AnyObserver<Void>     = self._searchButtonPressed.asObserver()

  lazy var apiAlertTryAgainButtonPressed: AnyObserver<Void> = self._apiAlertTryAgainButtonPressed.asObserver()

  lazy var viewDidAppear:    AnyObserver<Void> = self._viewDidAppear.asObserver()
  lazy var viewDidDisappear: AnyObserver<Void> = self._viewDidDisappear.asObserver()

  // MARK: - Output

  lazy var page: Driver<LineType> = Observable.merge(self._pageSelected, self._pageDidTransition)
    .startWith(LineType.tram)
    .asDriver(onErrorDriveWith: .never())

  lazy var lines: Driver<[Line]> = self.lineResponse
    .values()
    .asDriver(onErrorJustReturn: [])

  lazy var showApiErrorAlert: Driver<SearchCardApiAlert> = self.lineResponse
    .errors()
    .map(toApiAlert)
    .asDriver(onErrorDriveWith: .never())

  let selectedLines: Driver<[Line]> = Observable.just([])
    .asDriver(onErrorDriveWith: .never())

  lazy var isLineSelectorVisible: Driver<Bool> = self.lines.map { $0.any }
  lazy var isPlaceholderVisible:  Driver<Bool> = self.isLineSelectorVisible.not()

  lazy var close: Driver<Void> = self._searchButtonPressed
    .map { _ in () }
    .asDriver(onErrorDriveWith: .never())

  // MARK: - Init

  init() {
    self._searchButtonPressed
      .withLatestFrom(self.selectedLines) { $1 }
      .bind(onNext: { SearchCardViewModel.startTracking($0) })
      .disposed(by: self.disposeBag)

    self._viewDidDisappear
      .withLatestFrom(self.page) { $1 }
      .withLatestFrom(self.selectedLines) { ($0, $1) }
      .map { SearchState(withSelected: $0.0, lines: $0.1) }
      .bind { SearchCardViewModel.saveState($0) }
      .disposed(by: self.disposeBag)
  }

  // MARK: - Managers

  private static func getSavedState() -> SearchState {
    return Managers.search.getState()
  }

  private static func saveState(_ state: SearchState) {
    Managers.search.save(state)
  }

  private static func startTracking(_ lines: [Line]) {
    Managers.tracking.start(lines)
  }

  // MARK: - Input/Output

  var inputs:  SearchCardViewModelInput  { return self }
  var outputs: SearchCardViewModelOutput { return self }
}

private func toApiAlert(_ error: ApiError) -> SearchCardApiAlert {
  switch error {
  case .noInternet:
    return .noInternet
  case .connectionError,
       .invalidResponse:
    return .connectionError
  }
}
