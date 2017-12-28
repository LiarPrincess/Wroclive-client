//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

private typealias TextStyles = LineSelectionHeaderViewConstants.TextStyles

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
      .map { createText($0.model) }
      .asDriver(onErrorDriveWith: .never())
  }

  // MARK: - Input/Output

  var inputs:  LineSelectionHeaderViewModelInput  { return self }
  var outputs: LineSelectionHeaderViewModelOutput { return self }
}

private func createText(_ sectionData: LineSelectionSectionData) -> NSAttributedString {
  return NSAttributedString(string: sectionData.lineSubtypeTranslation, attributes: TextStyles.header)
}
