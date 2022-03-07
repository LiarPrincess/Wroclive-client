// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import ReSwift
import WrocliveTestsShared
@testable import WrocliveFramework

// swiftlint:disable implicitly_unwrapped_optional

class SearchCardViewModelTests: XCTestCase,
                                ReduxTestCase,
                                EnvironmentTestCase,
                                SearchCardViewType {

  var store: Store<AppState>!
  var dispatchedActions: [Action]!
  var environment: Environment!

  var isShowingBookmarkNameInputAlert = false
  var isShowingBookmarkNoLineSelectedAlert = false
  var apiErrorAlert: ApiError?
  var refreshCount = 0
  var isClosing = false

  override func setUp() {
    super.setUp()
    self.setUpRedux()
    self.setUpEnvironment()

    self.isShowingBookmarkNameInputAlert = false
    self.isShowingBookmarkNoLineSelectedAlert = false
    self.apiErrorAlert = nil
    self.refreshCount = 0
    self.isClosing = false
  }

  // MARK: - View model

  func createViewModel(state: SearchCardState) -> SearchCardViewModel {
    self.storageManager.searchCardState = state

    let result = SearchCardViewModel(store: self.store, environment: self.environment)
    result.setView(view: self)
    return result
  }

  func showBookmarkNameInputAlert() {
    self.isShowingBookmarkNameInputAlert = true
  }

  func showBookmarkNoLineSelectedAlert() {
    self.isShowingBookmarkNoLineSelectedAlert = true
  }

  func showApiErrorAlert(error: ApiError) {
    self.apiErrorAlert = error
  }

  func refresh() {
    self.refreshCount += 1
  }

  func close(animated: Bool) {
    self.isClosing = true
  }

  // MARK: - Data

  lazy var lines: [Line] = {
    let line0 = Line(name: "1", type: .tram, subtype: .regular)
    let line1 = Line(name: "4", type: .tram, subtype: .regular)
    let line2 = Line(name: "20", type: .tram, subtype: .regular)
    let line3 = Line(name: "A", type: .bus, subtype: .regular)
    let line4 = Line(name: "D", type: .bus, subtype: .regular)
    return [line0, line1, line2, line3, line4]
  }()

  lazy var selectedLines: [Line] = {
    let result = Array(self.lines.dropFirst(2).dropLast(2))
    assert(result.any)
    return result
  }()

  // MARK: - State

  typealias LineResponse = AppState.ApiResponseState<[Line]>

  func setLineResponseState(_ response: LineResponse) {
    self.setState { $0.getLinesResponse = response }
  }

  // MARK: - Dummy error

  class DummyError: Error, Equatable {
    static func == (lhs: SearchCardViewModelTests.DummyError,
                    rhs: SearchCardViewModelTests.DummyError) -> Bool {
      return lhs === rhs
    }
  }

  // MARK: - Assert

  func assertStateAfterViewDidLoad(viewModel: SearchCardViewModel,
                                   file: StaticString = #file,
                                   line: UInt = #line) {
    XCTAssertEqual(self.dispatchedActions.count,
                   1,
                   "Dispatched actions count",
                   file: file,
                   line: line)
    XCTAssertTrue(self.isRequestLinesAction(at: 0),
                  "Expected to dispatch RequestLinesAction",
                  file: file,
                  line: line)

    self.assertCurrentView(viewModel: viewModel,
                           view: .loadingView,
                           file: file,
                           line: line)
    self.assertLines(viewModel: viewModel,
                     lines: [],
                     file: file,
                     line: line)

    XCTAssertFalse(self.isShowingBookmarkNameInputAlert,
                   "isShowingBookmarkNameInputAlert",
                   file: file,
                   line: line)
    XCTAssertFalse(self.isShowingBookmarkNoLineSelectedAlert,
                   "isShowingBookmarkNoLineSelectedAlert",
                   file: file,
                   line: line)

    XCTAssertEqual(self.refreshCount, 1, "refreshCount", file: file, line: line)
    XCTAssertNil(self.apiErrorAlert, "apiErrorAlert", file: file, line: line)
  }

  enum CurrentView: Equatable {
    case lineSelector
    case loadingView
  }

  func assertCurrentView(viewModel: SearchCardViewModel,
                         view expectedView: CurrentView,
                         file: StaticString = #file,
                         line: UInt = #line) {
    switch expectedView {
    case .lineSelector:
      XCTAssertTrue(viewModel.isLineSelectorVisible,
                    "isLineSelectorVisible",
                    file: file,
                    line: line)
      XCTAssertFalse(viewModel.isLoadingViewVisible,
                     "isLoadingViewVisible",
                     file: file,
                     line: line)
    case .loadingView:
      XCTAssertFalse(viewModel.isLineSelectorVisible,
                     "isLineSelectorVisible",
                     file: file,
                     line: line)
      XCTAssertTrue(viewModel.isLoadingViewVisible,
                    "isLoadingViewVisible",
                    file: file,
                    line: line)
    }
  }

  func assertLines(viewModel: SearchCardViewModel,
                   lines expectedLines: [Line],
                   file: StaticString = #file,
                   line: UInt = #line) {
    let busPage = viewModel.lineSelectorViewModel.busPageViewModel
    let tramPage = viewModel.lineSelectorViewModel.tramPageViewModel

    let busLines = busPage.sections.flatMap { $0.lines }
    let tramLines = tramPage.sections.flatMap { $0.lines }
    let lines = busLines + tramLines

    XCTAssertEqual(lines.count,
                   expectedLines.count,
                   "Lines - count",
                   file: file,
                   line: line)

    // Order may be different!
    for l in lines {
      XCTAssert(expectedLines.contains(l), "\(l)", file: file, line: line)
    }
  }
}
