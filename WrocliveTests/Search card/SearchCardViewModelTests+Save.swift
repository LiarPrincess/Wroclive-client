// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import WrocliveFramework

extension SearchCardViewModelTests {

  func test_viewDidDisappear_withoutChanges_doesNotSaveState() {
    let state = SearchCardState(page: .tram, selectedLines: self.selectedLines)
    let viewModel = self.createViewModel(state: state, response: .inProgress)

    viewModel.viewDidDisappear()
    XCTAssertEqual(self.storageManager.writeSearchCardStateCount, 0)
  }

  func test_viewDidDisappear_withPageChanged_savesState() {
    let state = SearchCardState(page: .tram, selectedLines: self.selectedLines)
    let viewModel = self.createViewModel(state: state, response: .inProgress)

    viewModel.viewDidSelectPage(page: .bus)
    viewModel.viewDidDisappear()

    XCTAssertEqual(self.storageManager.writeSearchCardStateCount, 1)
  }

  func test_viewDidDisappear_withSelectedLinesChanged_savesState() {
    let state = SearchCardState(page: .tram, selectedLines: self.selectedLines)
    let viewModel = self.createViewModel(state: state, response: .inProgress)

    viewModel.lineSelectorViewModel.setSelectedLines(lines: [])
    viewModel.viewDidDisappear()

    XCTAssertEqual(self.storageManager.writeSearchCardStateCount, 1)
  }
}
