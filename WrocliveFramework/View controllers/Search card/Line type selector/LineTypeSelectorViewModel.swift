// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import RxSwift
import RxCocoa

private typealias Localization = Localizable.Search

private let lineTypePages: [LineType] = [.tram, .bus]

public final class LineTypeSelectorViewModel {

  private let disposeBag = DisposeBag()

  // MARK: - Inputs

  public let didSelectIndex: AnyObserver<Int>

  // MARK: - Output

  public lazy var pages: [String] = lineTypePages.map(toPageName)

  public let selectedIndex: Driver<Int>

  // MARK: - Init

  public init(pageProp:     Observable<LineType>,
              onPageChange: @escaping (LineType) -> ()) {

    let _didSelectIndex = PublishSubject<Int>()
    self.didSelectIndex = _didSelectIndex.asObserver()

    self.selectedIndex = pageProp
      .map { lineTypePages.firstIndex(of: $0) }
      .unwrap()
      .distinctUntilChanged()
      .asDriver(onErrorDriveWith: .never())

    _didSelectIndex.asObservable()
      .filter { $0 >= 0 && $0 < lineTypePages.count }
      .map    { lineTypePages[$0] }
      .bind(onNext: onPageChange)
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
