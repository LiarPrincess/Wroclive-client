//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

private typealias TextStyles = LineSelectorCellConstants.TextStyles

protocol LineSelectorCellViewModelInput {
  var line:       AnyObserver<Line> { get }
  var isSelected: AnyObserver<Bool> { get }
}

protocol LineSelectorCellViewModelOutput {
  var text: Driver<NSAttributedString> { get }
}

class LineSelectorCellViewModel: LineSelectorCellViewModelInput, LineSelectorCellViewModelOutput {

  // MARK: - Properties

  private let _line       = PublishSubject<Line>()
  private let _isSelected = PublishSubject<Bool>()

  // MARK: - Input

  lazy var line:       AnyObserver<Line> = self._line.asObserver()
  lazy var isSelected: AnyObserver<Bool> = self._isSelected.asObserver()

  // MARK: - Output

  lazy var text: Driver<NSAttributedString> = {
    let lineName   = self._line.map { $0.name }.startWith("")
    let isSelected = self._isSelected.startWith(false)

    return Observable.combineLatest(lineName, isSelected)
      .distinctUntilChanged(areEqual)
      .map { createText($0.0, isSelected: $0.1) }
      .asDriver(onErrorDriveWith: .never())
  }()

  // MARK: - Input/Output

  var inputs:  LineSelectorCellViewModelInput  { return self }
  var outputs: LineSelectorCellViewModelOutput { return self }
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
