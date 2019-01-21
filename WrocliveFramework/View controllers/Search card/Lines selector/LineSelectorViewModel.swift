// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import RxSwift
import RxCocoa

public final class LineSelectorViewModel {

  private let disposeBag = DisposeBag()

  // MARK: - Inputs

  public let didTransitionToPage: AnyObserver<LineType>

  // MARK: - Output

  public let tramPageViewModel: LineSelectorPageViewModel
  public let busPageViewModel:  LineSelectorPageViewModel

  public let page: Driver<LineType>

  // MARK: - Init

  public init(pageProp:          Observable<LineType>,
              linesProp:         Observable<[Line]>,
              selectedLinesProp: Observable<[Line]>,
              onPageTransition:  @escaping (LineType) -> (),
              onLineSelected:    @escaping (Line) -> (),
              onLineDeselected:  @escaping (Line) -> ()) {

    let _didTransitionToPage = PublishSubject<LineType>()
    self.didTransitionToPage = _didTransitionToPage.asObserver()

    self.tramPageViewModel = createPageViewModel(
      type: .tram,
      linesProp:         linesProp,
      selectedLinesProp: selectedLinesProp,
      onLineSelected:    onLineSelected,
      onLineDeselected:  onLineDeselected
    )

    self.busPageViewModel = createPageViewModel(
      type: .bus,
      linesProp:         linesProp,
      selectedLinesProp: selectedLinesProp,
      onLineSelected:    onLineSelected,
      onLineDeselected:  onLineDeselected
    )

    self.page = pageProp
      .distinctUntilChanged()
      .asDriver(onErrorDriveWith: .never())

    _didTransitionToPage.asObservable()
      .bind(onNext: onPageTransition)
      .disposed(by: self.disposeBag)
  }
}

private func createPageViewModel(type lineType: LineType,
                                 linesProp:         Observable<[Line]>,
                                 selectedLinesProp: Observable<[Line]>,
                                 onLineSelected:    @escaping (Line) -> (),
                                 onLineDeselected:  @escaping (Line) -> ()) -> LineSelectorPageViewModel {

  return LineSelectorPageViewModel(
    linesProp:         linesProp.map(only(lineType)),
    selectedLinesProp: selectedLinesProp.map(only(lineType)),
    onLineSelected:    onLineSelected,
    onLineDeselected:  onLineDeselected
  )
}

private func only(_ lineType: LineType) -> ([Line]) -> [Line] {
  return { $0.filter(lineType) }
}
