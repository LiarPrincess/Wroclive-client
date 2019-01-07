// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import RxSwift
import RxTest
@testable import WrocliveFramework

// swiftlint:disable implicitly_unwrapped_optional

private typealias TextStyles = LineSelectorHeaderViewConstants.TextStyles

class LineSelectorHeaderViewModelTests: XCTestCase, RxTestCase, EnvironmentTestCase {

  var scheduler:  TestScheduler!
  var disposeBag: DisposeBag!

  override func setUp() {
    super.setUp()
    self.setUpRx()
    self.setUpEnvironment()
  }

  override func tearDown() {
    super.tearDown()
    self.tearDownEnvironment()
    self.tearDownRx()
  }

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
