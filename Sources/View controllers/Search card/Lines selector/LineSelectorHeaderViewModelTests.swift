//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import XCTest
@testable import Wroclive

private typealias Localization = Localizable.Search.Sections
private typealias TextStyles   = LineSelectorHeaderViewConstants.TextStyles

final class LineSelectorHeaderViewModelTests: XCTestCase {

  var lineSubtypes: [LineSubtype] {
    return [.regular, .express, .peakHour, .suburban, .zone, .limited, .temporary, .night]
  }

  func test_sections_haveValidNames() {
    for lineSubtype in self.lineSubtypes {
      let section = LineSelectorSection(model: LineSelectorSectionData(for: lineSubtype), items: [])
      let viewModel = LineSelectorHeaderViewModel(section)

      let translation = section.model.lineSubtypeTranslation
      XCTAssertEqual(viewModel.text, NSAttributedString(string: translation, attributes: TextStyles.header))
    }
  }
}
