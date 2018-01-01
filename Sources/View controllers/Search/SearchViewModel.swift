//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol SearchViewModelInput {
  var lineTypeSelectorPageChanged: AnyObserver<LineType> { get }
  var lineSelectorPageChanged:     AnyObserver<LineType> { get }

  var selectedLinesChanged: AnyObserver<[Line]> { get }

  var bookmarkButtonPressed: AnyObserver<Void> { get }
  var searchButtonPressed:   AnyObserver<Void> { get }

  var viewClosed: AnyObserver<Void> { get }
}

protocol SearchViewModelOutput {
  var page: Driver<LineType> { get }

  var lines:         Driver<[Line]> { get }
  var selectedLines: Driver<[Line]> { get }

  var isLineSelectorVisible: Driver<Bool> { get }
  var isPlaceholderVisible:  Driver<Bool> { get }

  var requestedTracking:         Driver<[Line]> { get }
  var requestedBookmarkCreation: Driver<[Line]> { get }

  var didClose: Driver<Void> { get }
}

class SearchViewModel: SearchViewModelInput, SearchViewModelOutput {

  // MARK: - Properties

  private let _page          = BehaviorSubject(value: LineType.tram)
  private let _lines         = BehaviorSubject(value: [Line]())
  private let _selectedLines = BehaviorSubject(value: [Line]())

  private let _lineTypeSelectorPageChanged = PublishSubject<LineType>()
  private let _lineSelectorPageChanged     = PublishSubject<LineType>()

  private let _bookmarkButtonPressed = PublishSubject<Void>()
  private let _searchButtonPressed   = PublishSubject<Void>()

  private let _viewClosed = PublishSubject<Void>()

  private let disposeBag = DisposeBag()

  // input
  lazy var lineTypeSelectorPageChanged: AnyObserver<LineType> = self._lineTypeSelectorPageChanged.asObserver()
  lazy var lineSelectorPageChanged:     AnyObserver<LineType> = self._lineSelectorPageChanged.asObserver()

  lazy var selectedLinesChanged: AnyObserver<[Line]> = self._selectedLines.asObserver()

  lazy var bookmarkButtonPressed: AnyObserver<Void> = self._bookmarkButtonPressed.asObserver()
  lazy var searchButtonPressed:   AnyObserver<Void> = self._searchButtonPressed.asObserver()

  lazy var viewClosed: AnyObserver<Void> = self._viewClosed.asObserver()

  // output
  let page: Driver<LineType>

  let lines:         Driver<[Line]>
  let selectedLines: Driver<[Line]>

  let isLineSelectorVisible: Driver<Bool>
  let isPlaceholderVisible:  Driver<Bool>

  let requestedTracking:         Driver<[Line]>
  let requestedBookmarkCreation: Driver<[Line]>

  let didClose: Driver<Void>

  // MARK: - Init

  init() {
    self.page          = self._page.asDriver(onErrorDriveWith: .never())
    self.lines         = self._lines.asDriver(onErrorDriveWith: .never())
    self.selectedLines = self._selectedLines.asDriver(onErrorDriveWith: .never())

    self.isLineSelectorVisible = self.lines
      .map(any)
      .asDriver(onErrorDriveWith: .never())

    self.isPlaceholderVisible = self.lines
      .map(isEmpty)
      .asDriver(onErrorDriveWith: .never())

    self.requestedTracking = self._searchButtonPressed
      .withLatestFrom(self.selectedLines) { $1 }
      .debug("requestedTracking")
      .asDriver(onErrorDriveWith: .never())

    self.requestedBookmarkCreation = self._bookmarkButtonPressed
      .withLatestFrom(self.selectedLines) { $1 }
      .debug("requestedBookmarkCreation")
      .asDriver(onErrorDriveWith: .never())

    self.didClose = self._viewClosed.asDriver(onErrorDriveWith: .never())

    self.initPageInputBindings()
    self.bindInputs()
  }

  private func initPageInputBindings() {
    self._lineTypeSelectorPageChanged
      .bind(to: self._page)
      .disposed(by: self.disposeBag)

    self._lineSelectorPageChanged
      .bind(to: self._page)
      .disposed(by: self.disposeBag)
  }

  private func bindInputs() {
    SearchCardNetworkAdapter.getAvailableLines()
      .bind(to: self._lines)
      .disposed(by: self.disposeBag)

//    Observable.just([line0, line1])
//      .bind(to: self._selectedLines)
//      .disposed(by: self.disposeBag)

//    self._selectedLines
//      .debug("_selectedLines")
//      .subscribe()
//      .disposed(by: self.disposeBag)

//    // did close -> self.saveState()
//    self._viewClosed
//      .debug("_viewClosed")
//      .subscribe()
//      .disposed(by: self.disposeBag)
  }

  // MARK: - State

  private static func getSavedState() -> SearchState {
    return Managers.search.getSavedState()
  }

  private static func saveState(_ state: SearchState) {
    Managers.search.saveState(state)
  }

  // MARK: - Input/Output

  var inputs:  SearchViewModelInput  { return self }
  var outputs: SearchViewModelOutput { return self }
}

// MARK: - Lines

private func any(_ lines: [Line]) -> Bool {
  return lines.any
}

private func isEmpty(_ lines: [Line]) -> Bool {
  return lines.isEmpty
}
