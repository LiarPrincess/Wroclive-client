// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import WrocliveFramework

extension SearchCardViewModelTests {

  // MARK: - Initial

  func test_takesInitialPage_from() {
    for page in [LineType.bus, LineType.tram] {
      let state = SearchCardState(page: page, selectedLines: [])
      let viewModel = self.createViewModel(state: state, response: .inProgress)
      XCTAssertEqual(viewModel.page, page)
      XCTAssertEqual(viewModel.lineSelectorViewModel.page, page)
      XCTAssertEqual(self.refreshCount, 0)
    }
  }

  // MARK: - View did select page

  func test_viewDidSelectPage() {
    let state = SearchCardState(page: .tram, selectedLines: [])
    let viewModel = self.createViewModel(state: state, response: .inProgress)
    XCTAssertEqual(viewModel.page, .tram)
    XCTAssertEqual(viewModel.lineSelectorViewModel.page, .tram)
    XCTAssertEqual(self.refreshCount, 0)

    // Bus
    viewModel.viewDidSelectPage(page: .bus)
    XCTAssertEqual(viewModel.page, .bus)
    XCTAssertEqual(viewModel.lineSelectorViewModel.page, .bus)
    XCTAssertEqual(self.refreshCount, 1)

    // Bus again
    viewModel.viewDidSelectPage(page: .bus)
    XCTAssertEqual(viewModel.page, .bus)
    XCTAssertEqual(viewModel.lineSelectorViewModel.page, .bus)
    XCTAssertEqual(self.refreshCount, 2)

    // Tram
    viewModel.viewDidSelectPage(page: .tram)
    XCTAssertEqual(viewModel.page, .tram)
    XCTAssertEqual(viewModel.lineSelectorViewModel.page, .tram)
    XCTAssertEqual(self.refreshCount, 3)

    // Tram again
    viewModel.viewDidSelectPage(page: .tram)
    XCTAssertEqual(viewModel.page, .tram)
    XCTAssertEqual(viewModel.lineSelectorViewModel.page, .tram)
    XCTAssertEqual(self.refreshCount, 4)
  }

  // MARK: - Line selector did select page

  func test_lineSelectorDidSelectPage() {
    let state = SearchCardState(page: .tram, selectedLines: [])
    let viewModel = self.createViewModel(state: state, response: .inProgress)
    XCTAssertEqual(viewModel.page, .tram)
    XCTAssertEqual(viewModel.lineSelectorViewModel.page, .tram)
    XCTAssertEqual(self.refreshCount, 0)

    viewModel.lineSelectorViewModel.viewDidTransitionToPage(page: .bus)
    XCTAssertEqual(viewModel.page, .bus)
    XCTAssertEqual(viewModel.lineSelectorViewModel.page, .bus)
    XCTAssertEqual(self.refreshCount, 1)

    viewModel.lineSelectorViewModel.viewDidTransitionToPage(page: .tram)
    XCTAssertEqual(viewModel.page, .tram)
    XCTAssertEqual(viewModel.lineSelectorViewModel.page, .tram)
    XCTAssertEqual(self.refreshCount, 2)
  }
}
