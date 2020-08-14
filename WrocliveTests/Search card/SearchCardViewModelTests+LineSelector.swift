// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import WrocliveFramework

private func XCTAssertLines(viewModel: SearchCardViewModel,
                            lines expectedLines: [Line],
                            file: StaticString = #file,
                            line: UInt = #line) {
  let busPage = viewModel.lineSelectorViewModel.busPageViewModel
  let tramPage = viewModel.lineSelectorViewModel.tramPageViewModel

  let busLines = busPage.sections.flatMap { $0.lines }
  let tramLines = tramPage.sections.flatMap { $0.lines }
  let lines = busLines + tramLines

  XCTAssertEqual(lines.count, expectedLines.count, "Count", file: file, line: line)

  // Order may be different!
  for l in lines {
    XCTAssert(expectedLines.contains(l), "\(l)", file: file, line: line)
  }
}

extension SearchCardViewModelTests {

  // MARK: - No response

  func test_noneLineResponse_dispatchAction_showLines() {
    // none
    let state = SearchCardState(page: .tram, selectedLines: self.selectedLines)
    let viewModel = self.createViewModel(state: state, response: .none)
    XCTAssertEqual(self.refreshCount, 0)
    XCTAssertNil(self.apiErrorAlert)
    XCTAssertFalse(viewModel.isLineSelectorVisible)
    XCTAssertTrue(viewModel.isPlaceholderVisible)
    XCTAssertLines(viewModel: viewModel, lines: [])

    XCTAssertEqual(self.dispatchedActions.count, 1)
    XCTAssertTrue(self.isRequestLinesAction(at: 0))

    self.setLineResponseState(.inProgress)
    XCTAssertEqual(self.refreshCount, 1) // New state
    XCTAssertNil(self.apiErrorAlert)
    XCTAssertFalse(viewModel.isLineSelectorVisible)
    XCTAssertTrue(viewModel.isPlaceholderVisible)
    XCTAssertEqual(self.dispatchedActions.count, 1) // No new actions
    XCTAssertLines(viewModel: viewModel, lines: [])

    let lines = self.lines
    self.setLineResponseState(.data(lines))
    XCTAssertEqual(self.refreshCount, 2) // New state
    XCTAssertNil(self.apiErrorAlert)
    XCTAssertTrue(viewModel.isLineSelectorVisible) // !!!
    XCTAssertFalse(viewModel.isPlaceholderVisible)
    XCTAssertEqual(self.dispatchedActions.count, 1) // No new actions
    XCTAssertLines(viewModel: viewModel, lines: lines)
  }

  func test_noneLineResponse_dispatchAction_emptyResponse_showsError() {
    // none
    let state = SearchCardState(page: .tram, selectedLines: self.selectedLines)
    let viewModel = self.createViewModel(state: state, response: .none)
    XCTAssertEqual(self.refreshCount, 0)
    XCTAssertNil(self.apiErrorAlert)
    XCTAssertFalse(viewModel.isLineSelectorVisible)
    XCTAssertTrue(viewModel.isPlaceholderVisible)
    XCTAssertLines(viewModel: viewModel, lines: [])

    XCTAssertEqual(self.dispatchedActions.count, 1)
    XCTAssertTrue(self.isRequestLinesAction(at: 0))

    self.setLineResponseState(.inProgress)
    XCTAssertEqual(self.refreshCount, 1) // New state
    XCTAssertNil(self.apiErrorAlert)
    XCTAssertFalse(viewModel.isLineSelectorVisible)
    XCTAssertTrue(viewModel.isPlaceholderVisible)
    XCTAssertEqual(self.dispatchedActions.count, 1) // No new actions
    XCTAssertLines(viewModel: viewModel, lines: [])

    self.setLineResponseState(.data([]))
    XCTAssertEqual(self.refreshCount, 2) // New state
    XCTAssertEqual(self.apiErrorAlert, .invalidResponse)
    XCTAssertFalse(viewModel.isLineSelectorVisible)
    XCTAssertTrue(viewModel.isPlaceholderVisible)
    XCTAssertEqual(self.dispatchedActions.count, 1) // No new actions
    XCTAssertLines(viewModel: viewModel, lines: [])
  }

  func test_noneLineResponse_dispatchAction_handleError() {
    // none
    let state = SearchCardState(page: .tram, selectedLines: self.selectedLines)
    let viewModel = self.createViewModel(state: state, response: .none)
    XCTAssertEqual(self.refreshCount, 0)
    XCTAssertNil(self.apiErrorAlert)
    XCTAssertFalse(viewModel.isLineSelectorVisible)
    XCTAssertTrue(viewModel.isPlaceholderVisible)
    XCTAssertLines(viewModel: viewModel, lines: [])

    XCTAssertEqual(self.dispatchedActions.count, 1)
    XCTAssertTrue(self.isRequestLinesAction(at: 0))

    self.setLineResponseState(.inProgress)
    XCTAssertEqual(self.refreshCount, 1) // New state
    XCTAssertNil(self.apiErrorAlert)
    XCTAssertFalse(viewModel.isLineSelectorVisible)
    XCTAssertTrue(viewModel.isPlaceholderVisible)
    XCTAssertEqual(self.dispatchedActions.count, 1) // No new actions
    XCTAssertLines(viewModel: viewModel, lines: [])

    self.setLineResponseState(.error(.invalidResponse))
    XCTAssertEqual(self.refreshCount, 2) // New state
    XCTAssertEqual(self.apiErrorAlert, .invalidResponse)
    XCTAssertFalse(viewModel.isLineSelectorVisible)
    XCTAssertTrue(viewModel.isPlaceholderVisible)
    XCTAssertEqual(self.dispatchedActions.count, 1) // No new actions
    XCTAssertLines(viewModel: viewModel, lines: [])
  }

  // MARK: - Cached response

  func test_cachedLineResponse_showsLines() {
    let lines = self.lines
    let state = SearchCardState(page: .tram, selectedLines: self.selectedLines)
    let viewModel = self.createViewModel(state: state, response: .data(lines))
    XCTAssertEqual(self.refreshCount, 0)
    XCTAssertNil(self.apiErrorAlert)
    XCTAssertTrue(viewModel.isLineSelectorVisible)
    XCTAssertFalse(viewModel.isPlaceholderVisible)
    XCTAssertLines(viewModel: viewModel, lines: lines)

    XCTAssertEqual(self.dispatchedActions.count, 0)
  }

  func test_cachedLineResponseError_dispatchAction_showLines() {
    let state = SearchCardState(page: .tram, selectedLines: self.selectedLines)
    let viewModel = self.createViewModel(state: state, response: .error(.invalidResponse))
    XCTAssertEqual(self.refreshCount, 0)
    XCTAssertNil(self.apiErrorAlert)
    XCTAssertFalse(viewModel.isLineSelectorVisible)
    XCTAssertTrue(viewModel.isPlaceholderVisible)
    XCTAssertLines(viewModel: viewModel, lines: [])

    XCTAssertEqual(self.dispatchedActions.count, 1)
    XCTAssertTrue(self.isRequestLinesAction(at: 0))

    self.setLineResponseState(.inProgress)
    XCTAssertEqual(self.refreshCount, 1) // New state
    XCTAssertNil(self.apiErrorAlert)
    XCTAssertFalse(viewModel.isLineSelectorVisible)
    XCTAssertTrue(viewModel.isPlaceholderVisible)
    XCTAssertEqual(self.dispatchedActions.count, 1) // No new actions
    XCTAssertLines(viewModel: viewModel, lines: [])

    let lines = self.lines
    self.setLineResponseState(.data(lines))
    XCTAssertEqual(self.refreshCount, 2) // New state
    XCTAssertNil(self.apiErrorAlert)
    XCTAssertTrue(viewModel.isLineSelectorVisible) // !!!
    XCTAssertFalse(viewModel.isPlaceholderVisible)
    XCTAssertEqual(self.dispatchedActions.count, 1) // No new actions
    XCTAssertLines(viewModel: viewModel, lines: lines)
  }

  func test_cachedLineResponseError_dispatchAction_handleError() {
    let state = SearchCardState(page: .tram, selectedLines: self.selectedLines)
    let viewModel = self.createViewModel(state: state, response: .error(.invalidResponse))
    XCTAssertEqual(self.refreshCount, 0)
    XCTAssertNil(self.apiErrorAlert)
    XCTAssertFalse(viewModel.isLineSelectorVisible)
    XCTAssertTrue(viewModel.isPlaceholderVisible)
    XCTAssertLines(viewModel: viewModel, lines: [])

    XCTAssertEqual(self.dispatchedActions.count, 1)
    XCTAssertTrue(self.isRequestLinesAction(at: 0))

    self.setLineResponseState(.inProgress)
    XCTAssertEqual(self.refreshCount, 1) // New state
    XCTAssertNil(self.apiErrorAlert)
    XCTAssertFalse(viewModel.isLineSelectorVisible)
    XCTAssertTrue(viewModel.isPlaceholderVisible)
    XCTAssertEqual(self.dispatchedActions.count, 1) // No new actions
    XCTAssertLines(viewModel: viewModel, lines: [])

    self.setLineResponseState(.error(.invalidResponse))
    XCTAssertEqual(self.refreshCount, 2) // New state
    XCTAssertEqual(self.apiErrorAlert, .invalidResponse)
    XCTAssertFalse(viewModel.isLineSelectorVisible)
    XCTAssertTrue(viewModel.isPlaceholderVisible)
    XCTAssertEqual(self.dispatchedActions.count, 1) // No new actions
    XCTAssertLines(viewModel: viewModel, lines: [])
  }

  // MARK: - Again button

  func test_tryAgainLineResponse_dispatchAction_showLines() {
    // inProgress
    let state = SearchCardState(page: .tram, selectedLines: self.selectedLines)
    let viewModel = self.createViewModel(state: state, response: .inProgress)
    XCTAssertEqual(self.refreshCount, 0)
    XCTAssertNil(self.apiErrorAlert)
    XCTAssertFalse(viewModel.isLineSelectorVisible)
    XCTAssertTrue(viewModel.isPlaceholderVisible)
    XCTAssertLines(viewModel: viewModel, lines: [])
    XCTAssertEqual(self.dispatchedActions.count, 0)

    self.setLineResponseState(.error(.reachabilityError))
    XCTAssertEqual(self.refreshCount, 1) // New state
    XCTAssertEqual(self.apiErrorAlert, .reachabilityError)
    XCTAssertFalse(viewModel.isLineSelectorVisible)
    XCTAssertTrue(viewModel.isPlaceholderVisible)
    XCTAssertLines(viewModel: viewModel, lines: [])
    XCTAssertEqual(self.dispatchedActions.count, 0)

    // Reset, so we don't miss next error (which should NOT happen)
    self.apiErrorAlert = nil

    viewModel.viewDidPressAlertTryAgainButton()
    XCTAssertEqual(self.dispatchedActions.count, 1)
    XCTAssertTrue(self.isRequestLinesAction(at: 0))

    self.setLineResponseState(.inProgress)
    XCTAssertEqual(self.refreshCount, 2) // New state
    XCTAssertNil(self.apiErrorAlert)
    XCTAssertFalse(viewModel.isLineSelectorVisible)
    XCTAssertTrue(viewModel.isPlaceholderVisible)
    XCTAssertEqual(self.dispatchedActions.count, 1) // No new actions
    XCTAssertLines(viewModel: viewModel, lines: [])

    let lines = self.lines
    self.setLineResponseState(.data(lines))
    XCTAssertEqual(self.refreshCount, 3) // New state
    XCTAssertNil(self.apiErrorAlert)
    XCTAssertTrue(viewModel.isLineSelectorVisible) // !!!
    XCTAssertFalse(viewModel.isPlaceholderVisible)
    XCTAssertEqual(self.dispatchedActions.count, 1) // No new actions
    XCTAssertLines(viewModel: viewModel, lines: lines)
  }

  func test_tryAgainLineResponse_dispatchAction_handleError() {
    // inProgress
    let state = SearchCardState(page: .tram, selectedLines: self.selectedLines)
    let viewModel = self.createViewModel(state: state, response: .inProgress)
    XCTAssertEqual(self.refreshCount, 0)
    XCTAssertNil(self.apiErrorAlert)
    XCTAssertFalse(viewModel.isLineSelectorVisible)
    XCTAssertTrue(viewModel.isPlaceholderVisible)
    XCTAssertLines(viewModel: viewModel, lines: [])
    XCTAssertEqual(self.dispatchedActions.count, 0)

    self.setLineResponseState(.error(.reachabilityError))
    XCTAssertEqual(self.refreshCount, 1) // New state
    XCTAssertEqual(self.apiErrorAlert, .reachabilityError)
    XCTAssertFalse(viewModel.isLineSelectorVisible)
    XCTAssertTrue(viewModel.isPlaceholderVisible)
    XCTAssertLines(viewModel: viewModel, lines: [])
    XCTAssertEqual(self.dispatchedActions.count, 0)

    // Reset, so we don't miss next error (which should NOT happen)
    self.apiErrorAlert = nil

    viewModel.viewDidPressAlertTryAgainButton()
    XCTAssertEqual(self.dispatchedActions.count, 1)
    XCTAssertTrue(self.isRequestLinesAction(at: 0))

    self.setLineResponseState(.inProgress)
    XCTAssertEqual(self.refreshCount, 2) // New state
    XCTAssertNil(self.apiErrorAlert)
    XCTAssertFalse(viewModel.isLineSelectorVisible)
    XCTAssertTrue(viewModel.isPlaceholderVisible)
    XCTAssertEqual(self.dispatchedActions.count, 1) // No new actions
    XCTAssertLines(viewModel: viewModel, lines: [])

    self.setLineResponseState(.error(.invalidResponse))
    XCTAssertEqual(self.refreshCount, 3) // New state
    XCTAssertEqual(self.apiErrorAlert, .invalidResponse)
    XCTAssertFalse(viewModel.isLineSelectorVisible)
    XCTAssertTrue(viewModel.isPlaceholderVisible)
    XCTAssertEqual(self.dispatchedActions.count, 1) // No new actions
    XCTAssertLines(viewModel: viewModel, lines: [])
  }

  // MARK: - Other

  func test_duplicateResponse_none_doesNothing() {
    let state = SearchCardState(page: .tram, selectedLines: self.selectedLines)
    let viewModel = self.createViewModel(state: state, response: .none)
    XCTAssertEqual(self.refreshCount, 0)
    XCTAssertNil(self.apiErrorAlert)
    XCTAssertFalse(viewModel.isLineSelectorVisible)
    XCTAssertTrue(viewModel.isPlaceholderVisible)
    XCTAssertLines(viewModel: viewModel, lines: [])

    XCTAssertEqual(self.dispatchedActions.count, 1)
    XCTAssertTrue(self.isRequestLinesAction(at: 0))

    self.setLineResponseState(.none)
    XCTAssertEqual(self.refreshCount, 1) // New state
    XCTAssertNil(self.apiErrorAlert)
    XCTAssertFalse(viewModel.isLineSelectorVisible)
    XCTAssertTrue(viewModel.isPlaceholderVisible)
    XCTAssertLines(viewModel: viewModel, lines: [])

    XCTAssertEqual(self.dispatchedActions.count, 1) // No new dispatch!
    XCTAssertTrue(self.isRequestLinesAction(at: 0))
  }

  func test_duplicateResponse_data_doesNothing() {
    let lines = self.lines

    let state = SearchCardState(page: .tram, selectedLines: self.selectedLines)
    let viewModel = self.createViewModel(state: state, response: .data(lines))
    XCTAssertEqual(self.refreshCount, 0)
    XCTAssertNil(self.apiErrorAlert)
    XCTAssertTrue(viewModel.isLineSelectorVisible)
    XCTAssertFalse(viewModel.isPlaceholderVisible)
    XCTAssertLines(viewModel: viewModel, lines: lines)

    XCTAssertEqual(self.dispatchedActions.count, 0)

    self.setLineResponseState(.data(lines))
    XCTAssertEqual(self.refreshCount, 1) // New state
    XCTAssertNil(self.apiErrorAlert)
    XCTAssertTrue(viewModel.isLineSelectorVisible)
    XCTAssertFalse(viewModel.isPlaceholderVisible)
    XCTAssertLines(viewModel: viewModel, lines: lines)

    XCTAssertEqual(self.dispatchedActions.count, 0)
  }

  func test_duplicateResponse_error_doesNothing() {
    let apiErrors: [ApiError] = [
      .invalidResponse,
      .reachabilityError,
      .otherError(DummyError())
    ]

    for apiError in apiErrors {
      // We have to start with some other (non-error) state
      let state = SearchCardState(page: .tram, selectedLines: self.selectedLines)
      let viewModel = self.createViewModel(state: state, response: .inProgress)
      XCTAssertEqual(self.refreshCount, 0)
      XCTAssertNil(self.apiErrorAlert)
      XCTAssertFalse(viewModel.isLineSelectorVisible)
      XCTAssertTrue(viewModel.isPlaceholderVisible)
      XCTAssertEqual(self.dispatchedActions.count, 0)
      XCTAssertLines(viewModel: viewModel, lines: [])

      self.setLineResponseState(.error(apiError))
      XCTAssertEqual(self.refreshCount, 1) // New state
      XCTAssertEqual(self.apiErrorAlert, apiError)
      XCTAssertFalse(viewModel.isLineSelectorVisible)
      XCTAssertTrue(viewModel.isPlaceholderVisible)
      XCTAssertLines(viewModel: viewModel, lines: [])
      XCTAssertEqual(self.dispatchedActions.count, 0)

      self.apiErrorAlert = nil // Reset to check if we call it again

      self.setLineResponseState(.error(apiError))
      XCTAssertEqual(self.refreshCount, 2) // New state
      XCTAssertNil(self.apiErrorAlert)
      XCTAssertFalse(viewModel.isLineSelectorVisible)
      XCTAssertTrue(viewModel.isPlaceholderVisible)
      XCTAssertLines(viewModel: viewModel, lines: [])
      XCTAssertEqual(self.dispatchedActions.count, 0)
    }
  }
}
