//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol SearchViewModelInput {
  var viewClosed: AnyObserver<Void> { get }
}

protocol SearchViewModelOutput {
  var selectedLines: Driver<[Line]> { get }

  var searchButtonPressed: Driver<Void> { get }

  var didClose: Driver<Void> { get }
}

class SearchViewModel: SearchViewModelInput, SearchViewModelOutput {

  // MARK: - Properties

  private let _viewClosed = PublishSubject<Void>()

  private let disposeBag = DisposeBag()

  // input
  lazy var viewClosed: AnyObserver<Void> = self._viewClosed.asObserver()

  // output
  let selectedLines: Driver<[Line]> = Driver.just([])
  let searchButtonPressed: Driver<Void> = Driver.never().asDriver()
  let didClose: Driver<Void>

  // MARK: - Init

  init() {
    self.didClose = self._viewClosed.asDriver(onErrorDriveWith: .never())

    self.bindInputs()
  }

  private func bindInputs() {}

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
