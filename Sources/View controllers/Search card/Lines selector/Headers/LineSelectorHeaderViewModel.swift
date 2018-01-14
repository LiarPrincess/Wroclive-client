//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

private typealias TextStyles = LineSelectorHeaderViewConstants.TextStyles

protocol LineSelectorHeaderViewModelInput {
  var section: AnyObserver<LineSelectorSection> { get }
}

protocol LineSelectorHeaderViewModelOutput {
  var text: Driver<NSAttributedString> { get }
}

class LineSelectorHeaderViewModel: LineSelectorHeaderViewModelInput, LineSelectorHeaderViewModelOutput {

  // MARK: - Properties

  private let _section = PublishSubject<LineSelectorSection>()

  // MARK: - Input

  lazy var section: AnyObserver<LineSelectorSection> = self._section.asObserver()

  // MARK: - Output

  lazy var text: Driver<NSAttributedString> = self._section
    .map { createText($0.model) }
    .asDriver(onErrorDriveWith: .never())

  // MARK: - Input/Output

  var inputs:  LineSelectorHeaderViewModelInput  { return self }
  var outputs: LineSelectorHeaderViewModelOutput { return self }
}

private func createText(_ sectionData: LineSelectorSectionData) -> NSAttributedString {
  return NSAttributedString(string: sectionData.lineSubtypeTranslation, attributes: TextStyles.header)
}
