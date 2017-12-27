//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

private typealias TextStyles   = LineSelectionHeaderViewConstants.TextStyles
private typealias Localization = Localizable.LineSelection.SectionName

protocol LineSelectionHeaderViewModelInput {
  var section: AnyObserver<LineSelectionSection> { get }
}

protocol LineSelectionHeaderViewModelOutput {
  var text: Driver<NSAttributedString> { get }
}

class LineSelectionHeaderViewModel: LineSelectionHeaderViewModelInput, LineSelectionHeaderViewModelOutput {
  private let _section = PublishSubject<LineSelectionSection>()

  // input
  lazy var section: AnyObserver<LineSelectionSection> = self._section.asObserver()

  // output
  let text: Driver<NSAttributedString>

  init() {
    self.text = self._section
      .map { createText($0.subtype) }
      .asDriver(onErrorDriveWith: .never())
  }

  // MARK: - Input/Output

  var inputs:  LineSelectionHeaderViewModelInput  { return self }
  var outputs: LineSelectionHeaderViewModelOutput { return self }
}

private func createText(_ subtype: LineSubtype) -> NSAttributedString {
  let value = createTextValue(subtype)
  return NSAttributedString(string: value, attributes: TextStyles.header)
}

private func createTextValue(_ subtype: LineSubtype) -> String {
  switch subtype {
  case .regular:   return Localization.regular
  case .express:   return Localization.express
  case .peakHour:  return Localization.peakHour
  case .suburban:  return Localization.suburban
  case .zone:      return Localization.zone
  case .limited:   return Localization.limited
  case .temporary: return Localization.temporary
  case .night:     return Localization.night
  }
}
