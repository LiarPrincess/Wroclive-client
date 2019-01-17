// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import ReSwift
import RxSwift
import RxCocoa

public final class LineSelectorViewModel {

  private let disposeBag = DisposeBag()

  // MARK: - Inputs

  public let didTransitionToPage: AnyObserver<LineType>

  // MARK: - Output

  let tramPageViewModel: LineSelectorPageViewModel
  let busPageViewModel:  LineSelectorPageViewModel

  public let page: Driver<LineType>

  // MARK: - Init

  public init(_ store: Store<AppState>) {
    self.tramPageViewModel = LineSelectorPageViewModel(store, for: .tram)
    self.busPageViewModel  = LineSelectorPageViewModel(store, for: .bus)

    let _didTransitionToPage = PublishSubject<LineType>()
    self.didTransitionToPage = _didTransitionToPage.asObserver()

    self.page = store.rx.state
      .map { $0.userData.searchCardState.page }
      .distinctUntilChanged()
      .asDriver(onErrorDriveWith: .never())

    _didTransitionToPage.asObservable()
      .bind { store.dispatch(SearchCardStateAction.selectPage($0)) }
      .disposed(by: self.disposeBag)
  }
}
