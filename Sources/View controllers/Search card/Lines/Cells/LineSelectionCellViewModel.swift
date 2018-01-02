//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

private typealias TextStyles = LineSelectionCellConstants.TextStyles

protocol LineSelectionCellViewModelInput {
  var lineChanged:       AnyObserver<Line> { get }
  var isSelectedChanged: AnyObserver<Bool> { get }
}

protocol LineSelectionCellViewModelOutput {
  var text: Driver<NSAttributedString> { get }
}

class LineSelectionCellViewModel: LineSelectionCellViewModelInput, LineSelectionCellViewModelOutput {
  private let _lineChanged       = PublishSubject<Line>()
  private let _isSelectedChanged = PublishSubject<Bool>()

  // input
  lazy var lineChanged:       AnyObserver<Line> = self._lineChanged.asObserver()
  lazy var isSelectedChanged: AnyObserver<Bool> = self._isSelectedChanged.asObserver()

  // output
  let text: Driver<NSAttributedString>

  init() {
    let lineName   = self._lineChanged.map { $0.name }.startWith("")
    let isSelected = self._isSelectedChanged.startWith(false)

    self.text = Observable.combineLatest(lineName, isSelected)
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
