// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import WrocliveFramework

class LineSelectorViewModelTests: XCTestCase, LineSelectorViewType {

  private let lines = LineSelectorSectionTests.lines

  /// Updated when view model calls `view.onPageTransition`.
  private var onPageTransitionArgument: LineType?
  private var refreshCount = 0

  // MARK: - View model

  func createViewModel(initialPage: LineType) -> LineSelectorViewModel {
    let result = LineSelectorViewModel(
      initialPage: initialPage,
      onPageTransition: { [weak self] page in self?.onPageTransition(page: page) }
    )

    result.setView(view: self)
    self.refreshCount = 0
    return result
  }

  func refresh() {
    self.refreshCount += 1
  }

  func onPageTransition(page: LineType) {
    self.onPageTransitionArgument = page
  }

  // MARK: - Page

  func test_settingPage_updatesView_ifNeeded() {
    let viewModel = self.createViewModel(initialPage: .tram)
    XCTAssertEqual(self.refreshCount, 0)
    XCTAssertEqual(viewModel.page, .tram)

    // Bus
    viewModel.setPage(page: .bus)
    XCTAssertEqual(self.refreshCount, 1)
    XCTAssertEqual(viewModel.page, .bus)

    // Bus again (should be ignored)
    viewModel.setPage(page: .bus)
    XCTAssertEqual(self.refreshCount, 1)
    XCTAssertEqual(viewModel.page, .bus)

    // Tram
    viewModel.setPage(page: .tram)
    XCTAssertEqual(self.refreshCount, 2)
    XCTAssertEqual(viewModel.page, .tram)

    // Tram again (should be ignored)
    viewModel.setPage(page: .tram)
    XCTAssertEqual(self.refreshCount, 2)
    XCTAssertEqual(viewModel.page, .tram)
  }

  func test_onViewPageChange_callsCallback() {
    let viewModel = self.createViewModel(initialPage: .tram)
    XCTAssertEqual(self.refreshCount, 0)
    XCTAssertNil(self.onPageTransitionArgument)

    viewModel.viewDidTransitionToPage(page: .bus)
    XCTAssertEqual(self.refreshCount, 0)
    XCTAssertEqual(self.onPageTransitionArgument, .bus)
    self.onPageTransitionArgument = nil

    viewModel.viewDidTransitionToPage(page: .tram)
    XCTAssertEqual(self.refreshCount, 0)
    XCTAssertEqual(self.onPageTransitionArgument, .tram)
    self.onPageTransitionArgument = nil
  }

  // MARK: - Lines, selected lines

  func test_setLines_assignsThem_toCorrectPage() {
    let viewModel = self.createViewModel(initialPage: .tram)
    XCTAssertEqual(self.refreshCount, 0)

    viewModel.setLines(lines: self.lines)
    XCTAssertEqual(self.refreshCount, 0)

    let busPage = viewModel.busPageViewModel
    let busLines = self.getLines(from: busPage.sections)
    XCTAssertAll(lines: busLines, haveType: .bus)

    let tramPage = viewModel.tramPageViewModel
    let tramLines = self.getLines(from: tramPage.sections)
    XCTAssertAll(lines: tramLines, haveType: .tram)
  }

  func test_setSelectedLines_assignsThem_toCorrectPage() {
    let viewModel = self.createViewModel(initialPage: .tram)
    XCTAssertEqual(self.refreshCount, 0)

    viewModel.setSelectedLines(lines: self.lines)
    XCTAssertEqual(self.refreshCount, 0)

    let busPage = viewModel.busPageViewModel
    let busLines = busPage.selectedLines
    XCTAssertAll(lines: busLines, haveType: .bus)

    let tramPage = viewModel.tramPageViewModel
    let tramLines = tramPage.selectedLines
    XCTAssertAll(lines: tramLines, haveType: .tram)

  }

  private func getLines(from sections: [LineSelectorSection]) -> [Line] {
    return sections.flatMap { $0.lines }
  }
}
