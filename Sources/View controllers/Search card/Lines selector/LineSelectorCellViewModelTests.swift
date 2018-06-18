//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import XCTest
@testable import Wroclive

private typealias TextStyles = LineSelectorCellConstants.TextStyles

final class LineSelectorCellViewModelTests: XCTestCase {

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
