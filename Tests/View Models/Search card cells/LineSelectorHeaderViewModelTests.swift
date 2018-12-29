//// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
//// If a copy of the MPL was not distributed with this file,
//// You can obtain one at http://mozilla.org/MPL/2.0/.
//
//import XCTest
//@testable import Wroclive
//
//private typealias TextStyles = LineSelectorHeaderViewConstants.TextStyles
//
//class LineSelectorHeaderViewModelTests: TestCase {
//
//  var lineSubtypes: [LineSubtype] {
//    return [.regular, .express, .peakHour, .suburban, .zone, .limited, .temporary, .night]
//  }
//
//  func test_sections_haveValidNames() {
//    for lineSubtype in self.lineSubtypes {
//      let section = LineSelectorSection(model: LineSelectorSectionData(for: lineSubtype), items: [])
//      let viewModel = LineSelectorHeaderViewModel(section)
//
//      let translation = section.model.lineSubtypeTranslation
//      XCTAssertEqual(viewModel.text, NSAttributedString(string: translation, attributes: TextStyles.header))
//    }
//  }
//}
