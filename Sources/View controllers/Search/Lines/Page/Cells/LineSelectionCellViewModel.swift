//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

private typealias TextStyles = LineSelectionCellConstants.TextStyles

protocol LineSelectionCellViewModelInput {
  var line:       AnyObserver<Line> { get }
  var isSelected: AnyObserver<Bool> { get }
}

protocol LineSelectionCellViewModelOutput {
  var text: Driver<NSAttributedString> { get }
}

class LineSelectionCellViewModel: LineSelectionCellViewModelInput, LineSelectionCellViewModelOutput {
  private let _line       = PublishSubject<Line>()
  private let _isSelected = BehaviorSubject(value: false)
  private let _lineName   = BehaviorSubject(value: "")

  private let disposeBag = DisposeBag()

  // input
  lazy var line:       AnyObserver<Line> = self._line.asObserver()
  lazy var isSelected: AnyObserver<Bool> = self._isSelected.asObserver()

  // output
  let text: Driver<NSAttributedString>

  init() {
    self._line
      .map { $0.name }
      .bind(to: self._lineName)
      .disposed(by: self.disposeBag)

    let didChangeLineName   = self._lineName.map   { _ in () }
    let didChangeIsSelected = self._isSelected.map { _ in () }

    self.text = Observable.merge(didChangeLineName, didChangeIsSelected)
      .withLatestFrom(self._lineName)   { $1 }
      .withLatestFrom(self._isSelected) { ($0, $1) }
      .distinctUntilChanged(areEqual)
      .map { createText($0.0, isSelected: $0.1) }
      .asDriver(onErrorDriveWith: .never())
  }

  // MARK: - Input/Output

  var inputs:  LineSelectionCellViewModelInput  { return self }
  var outputs: LineSelectionCellViewModelOutput { return self }
}

private func areEqual<T1: Equatable, T2: Equatable> (lhs: (T1, T2), rhs: (T1, T2)) -> Bool {
  return (lhs.0 == rhs.0) && (lhs.1 == rhs.1)
}

private func createText(_ value: String, isSelected: Bool) -> NSAttributedString {
  let attributes = createTextAttributes(isSelected: isSelected)
  return NSAttributedString(string: value.uppercased(), attributes: attributes)
}

private func createTextAttributes(isSelected: Bool) -> TextAttributes {
  switch isSelected {
  case true:  return TextStyles.selected
  case false: return TextStyles.notSelected
  }
}
