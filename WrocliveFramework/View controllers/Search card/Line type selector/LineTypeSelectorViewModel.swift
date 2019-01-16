// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import ReSwift
import RxSwift
import RxCocoa

private typealias Localization = Localizable.Search

private let availableLineTypes: [LineType] = [.tram, .bus]

public final class LineTypeSelectorViewModel {

  private let disposeBag = DisposeBag()

  // MARK: - Inputs

  public let didSelectIndex: AnyObserver<Int>

  // MARK: - Output

  public lazy var pages: [String] = availableLineTypes.map(toPageName)

  public let selectedIndex: Driver<Int>

  // MARK: - Init

  public init(_ store: Store<AppState>) {
    let _didSelectIndex = PublishSubject<Int>()
    self.didSelectIndex = _didSelectIndex.asObserver()

    self.selectedIndex = store.rx.state
      .map { $0.userData.searchCardState.page }
      .map { availableLineTypes.firstIndex(of: $0) }
      .unwrap()
      .distinctUntilChanged()
      .asDriver(onErrorDriveWith: .never())

    _didSelectIndex.asObservable()
      .filter { $0 >= 0 && $0 < availableLineTypes.count }
      .map    { availableLineTypes[$0] }
      .bind   { store.dispatch(SearchCardStateAction.selectPage($0)) }
      .disposed(by: self.disposeBag)
  }
}

// MARK: - Indices

private func toPageName(_ lineType: LineType) -> String {
  switch lineType {
  case .tram: return Localization.Pages.tram
  case .bus:  return Localization.Pages.bus
  }
}
