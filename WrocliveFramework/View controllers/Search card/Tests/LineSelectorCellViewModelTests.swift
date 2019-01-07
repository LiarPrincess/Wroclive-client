// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import RxSwift
import RxTest
@testable import WrocliveFramework

// swiftlint:disable implicitly_unwrapped_optional

private typealias TextStyles = LineSelectorCellConstants.TextStyles

class LineSelectorCellViewModelTests: XCTestCase, RxTestCase, EnvironmentTestCase {

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

  func test_initialCell_hasDeselectedStyle() {
    let line      = Line(name: "0l", type: .tram, subtype: .regular)
    let viewModel = LineSelectorCellViewModel(line)
    XCTAssertEqual(viewModel.text, NSAttributedString(string: "0L", attributes: TextStyles.notSelected))
  }

  func test_selectedCell_hasSelectedStyle() {
    let line      = Line(name: "0l", type: .tram, subtype: .regular)
    let viewModel = LineSelectorCellViewModel(line)
    viewModel.updateText(isCellSelected: true)
    XCTAssertEqual(viewModel.text, NSAttributedString(string: "0L", attributes: TextStyles.selected))
  }

  func test_deselectedCell_hasDeselectedStyle() {
    let line      = Line(name: "0l", type: .tram, subtype: .regular)
    let viewModel = LineSelectorCellViewModel(line)
    viewModel.updateText(isCellSelected: true)
    viewModel.updateText(isCellSelected: false)
    XCTAssertEqual(viewModel.text, NSAttributedString(string: "0L", attributes: TextStyles.notSelected))
  }
}
