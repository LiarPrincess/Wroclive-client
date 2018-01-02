//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

// TODO: lines (+failed alerts, +retry)
// TODO: selected lines
// TODO: bookmark
// TODO: use saved state

protocol SearchCardViewModelInput {
  var lineTypeSelectorPageChanged: AnyObserver<LineType> { get }
  var lineSelectorPageChanged:     AnyObserver<LineType> { get }

//  var selectedLinesChanged: AnyObserver<[Line]> { get }

  var bookmarkButtonPressed: AnyObserver<Void> { get }
  var searchButtonPressed:   AnyObserver<Void> { get }

  var didClose: AnyObserver<Void> { get }
}

protocol SearchCardViewModelOutput {
  var page: Driver<LineType> { get }

  var lines:         Driver<[Line]> { get }
//  var selectedLines: Driver<[Line]> { get }

  var isLineSelectorVisible: Driver<Bool> { get }
  var isPlaceholderVisible:  Driver<Bool> { get }

  var shouldClose: Driver<Void> { get }
}

class SearchCardViewModel: SearchCardViewModelInput, SearchCardViewModelOutput {

  // MARK: - Properties

  private let _lineTypeSelectorPageChanged = PublishSubject<LineType>()
  private let _lineSelectorPageChanged     = PublishSubject<LineType>()
  private let _bookmarkButtonPressed       = PublishSubject<Void>()
  private let _searchButtonPressed         = PublishSubject<Void>()
  private let _didClose                    = PublishSubject<Void>()

  private let disposeBag = DisposeBag()

  // MARK: - Input

  lazy var lineTypeSelectorPageChanged: AnyObserver<LineType> = self._lineTypeSelectorPageChanged.asObserver()
  lazy var lineSelectorPageChanged:     AnyObserver<LineType> = self._lineSelectorPageChanged.asObserver()
  lazy var bookmarkButtonPressed:       AnyObserver<Void>     = self._bookmarkButtonPressed.asObserver()
  lazy var searchButtonPressed:         AnyObserver<Void>     = self._searchButtonPressed.asObserver()
  lazy var didClose:                    AnyObserver<Void>     = self._didClose.asObserver()

  // MARK: - Output

  lazy var page: Driver<LineType> = Observable.merge(self._lineTypeSelectorPageChanged, self._lineSelectorPageChanged)
    .startWith(LineType.tram)
    .asDriver(onErrorDriveWith: .never())

  lazy var lines: Driver<[Line]> = SearchCardNetworkAdapter.getAvailableLines()
    .asDriver(onErrorDriveWith: .never())

  let selectedLines: Driver<[Line]> = Observable.just([])
    .asDriver(onErrorDriveWith: .never())

  lazy var isLineSelectorVisible: Driver<Bool> = self.lines
    .map { $0.any }

  // swiftlint:disable:next array_init
  lazy var isPlaceholderVisible: Driver<Bool> = self.isLineSelectorVisible
    .map { !$0 }

  lazy var shouldClose: Driver<Void> = self._searchButtonPressed
    .map { _ in () }
    .asDriver(onErrorDriveWith: .never())

  // MARK: - Init

  init() {

//    self.selectedLines = self._selectedLines.asDriver(onErrorDriveWith: .never())

//    xxx = self._bookmarkButtonPressed
//      .withLatestFrom(self.selectedLines) { $1 }
//      .debug("requestedBookmarkCreation")
//      .asDriver(onErrorDriveWith: .never())

    self._searchButtonPressed
      .withLatestFrom(self.selectedLines) { $1 }
      .bind(onNext: { SearchCardViewModel.startTracking($0) })
      .disposed(by: self.disposeBag)

    self._didClose
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
