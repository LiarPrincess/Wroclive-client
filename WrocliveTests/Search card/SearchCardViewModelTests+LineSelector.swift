// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import WrocliveTestsShared
@testable import WrocliveFramework

extension SearchCardViewModelTests {

  // MARK: - Response

  func test_response_withLines_showLineSelector() {
    let state = SearchCardState(page: .tram, selectedLines: self.selectedLines)
    let viewModel = self.createViewModel(state: state)

    viewModel.viewDidLoad()
    self.assertStateAfterViewDidLoad(viewModel: viewModel)

    self.setLineResponseState(.inProgress)
    XCTAssertEqual(self.refreshCount, 1)
    XCTAssertNil(self.apiErrorAlert)
    XCTAssertEqual(self.dispatchedActions.count, 1)
    self.assertCurrentView(viewModel: viewModel, view: .loadingView)
    self.assertLines(viewModel: viewModel, lines: [])

    let lines = self.lines
    self.setLineResponseState(.data(lines))
    XCTAssertEqual(self.refreshCount, 2)
    XCTAssertNil(self.apiErrorAlert)
    XCTAssertEqual(self.dispatchedActions.count, 1)
    self.assertCurrentView(viewModel: viewModel, view: .lineSelector)
    self.assertLines(viewModel: viewModel, lines: lines)
  }

  func test_response_withoutLines_showsError() {
    let state = SearchCardState(page: .tram, selectedLines: self.selectedLines)
    let viewModel = self.createViewModel(state: state)

    viewModel.viewDidLoad()
    self.assertStateAfterViewDidLoad(viewModel: viewModel)

    self.setLineResponseState(.inProgress)
    XCTAssertEqual(self.refreshCount, 1)
    XCTAssertNil(self.apiErrorAlert)
    XCTAssertEqual(self.dispatchedActions.count, 1)
    self.assertCurrentView(viewModel: viewModel, view: .loadingView)
    self.assertLines(viewModel: viewModel, lines: [])

    self.setLineResponseState(.data([]))
    XCTAssertEqual(self.refreshCount, 1) // Still loading
    XCTAssertEqual(self.apiErrorAlert, .invalidResponse) // <-- This
    XCTAssertEqual(self.dispatchedActions.count, 1)
    self.assertCurrentView(viewModel: viewModel, view: .loadingView)
    self.assertLines(viewModel: viewModel, lines: [])
  }

  func test_response_withError_handlesError() {
    let state = SearchCardState(page: .tram, selectedLines: self.selectedLines)
    let viewModel = self.createViewModel(state: state)

    viewModel.viewDidLoad()
    self.assertStateAfterViewDidLoad(viewModel: viewModel)

    self.setLineResponseState(.inProgress)
    XCTAssertEqual(self.refreshCount, 1)
    XCTAssertNil(self.apiErrorAlert)
    XCTAssertEqual(self.dispatchedActions.count, 1)
    self.assertCurrentView(viewModel: viewModel, view: .loadingView)
    self.assertLines(viewModel: viewModel, lines: [])

    self.setLineResponseState(.error(.invalidResponse))
    XCTAssertEqual(self.refreshCount, 1) // Still loading
    XCTAssertEqual(self.apiErrorAlert, .invalidResponse) // <-- This
    XCTAssertEqual(self.dispatchedActions.count, 1)
    self.assertCurrentView(viewModel: viewModel, view: .loadingView)
    self.assertLines(viewModel: viewModel, lines: [])
  }

  // MARK: - Again button

  func test_response_withError_tryAgain_dispatchesAction_showLines() {
    let state = SearchCardState(page: .tram, selectedLines: self.selectedLines)
    let viewModel = self.createViewModel(state: state)

    viewModel.viewDidLoad()
    self.assertStateAfterViewDidLoad(viewModel: viewModel)

    self.setLineResponseState(.error(.reachabilityError))
    XCTAssertEqual(self.refreshCount, 1)
    XCTAssertEqual(self.apiErrorAlert, .reachabilityError)
    XCTAssertEqual(self.dispatchedActions.count, 1)
    self.assertCurrentView(viewModel: viewModel, view: .loadingView)
    self.assertLines(viewModel: viewModel, lines: [])

    // Reset, so we don't miss next error (which should NOT happen)
    self.apiErrorAlert = nil

    viewModel.viewDidPressAlertTryAgainButton()
    XCTAssertEqual(self.dispatchedActions.count, 2)
    XCTAssertTrue(self.isRequestLinesAction(at: 1))

    self.setLineResponseState(.inProgress)
    XCTAssertEqual(self.refreshCount, 1)
    XCTAssertNil(self.apiErrorAlert)
    XCTAssertEqual(self.dispatchedActions.count, 2)
    self.assertCurrentView(viewModel: viewModel, view: .loadingView)
    self.assertLines(viewModel: viewModel, lines: [])

    let lines = self.lines
    self.setLineResponseState(.data(lines))
    XCTAssertEqual(self.refreshCount, 2)
    XCTAssertNil(self.apiErrorAlert)
    XCTAssertEqual(self.dispatchedActions.count, 2)
    self.assertCurrentView(viewModel: viewModel, view: .lineSelector)
    self.assertLines(viewModel: viewModel, lines: lines)
  }

  func test_response_withError_tryAgain_dispatchesAction_handlesError() {
    let state = SearchCardState(page: .tram, selectedLines: self.selectedLines)
    let viewModel = self.createViewModel(state: state)

    viewModel.viewDidLoad()
    self.assertStateAfterViewDidLoad(viewModel: viewModel)

    self.setLineResponseState(.error(.reachabilityError))
    XCTAssertEqual(self.refreshCount, 1)
    XCTAssertEqual(self.apiErrorAlert, .reachabilityError)
    XCTAssertEqual(self.dispatchedActions.count, 1)
    self.assertCurrentView(viewModel: viewModel, view: .loadingView)
    self.assertLines(viewModel: viewModel, lines: [])

    // Reset, so we don't miss next error (which should NOT happen)
    self.apiErrorAlert = nil

    viewModel.viewDidPressAlertTryAgainButton()
    XCTAssertEqual(self.dispatchedActions.count, 2)
    XCTAssertTrue(self.isRequestLinesAction(at: 1))

    self.setLineResponseState(.inProgress)
    XCTAssertEqual(self.refreshCount, 1)
    XCTAssertNil(self.apiErrorAlert)
    XCTAssertEqual(self.dispatchedActions.count, 2)
    self.assertCurrentView(viewModel: viewModel, view: .loadingView)
    self.assertLines(viewModel: viewModel, lines: [])

    self.setLineResponseState(.error(.invalidResponse))
    XCTAssertEqual(self.refreshCount, 1)
    XCTAssertEqual(self.apiErrorAlert, .invalidResponse)
    XCTAssertEqual(self.dispatchedActions.count, 2)
    self.assertCurrentView(viewModel: viewModel, view: .loadingView)
    self.assertLines(viewModel: viewModel, lines: [])
  }

  // MARK: - Other

  func test_duplicateResponse_inProgress_doesNothing() {
    let state = SearchCardState(page: .tram, selectedLines: self.selectedLines)
    let viewModel = self.createViewModel(state: state)

    viewModel.viewDidLoad()
    self.assertStateAfterViewDidLoad(viewModel: viewModel)

    self.setLineResponseState(.inProgress)
    XCTAssertEqual(self.refreshCount, 1)
    XCTAssertNil(self.apiErrorAlert)
    XCTAssertEqual(self.dispatchedActions.count, 1)
    self.assertCurrentView(viewModel: viewModel, view: .loadingView)
    self.assertLines(viewModel: viewModel, lines: [])

    self.setLineResponseState(.inProgress)
    XCTAssertEqual(self.refreshCount, 1)
    XCTAssertNil(self.apiErrorAlert)
    XCTAssertEqual(self.dispatchedActions.count, 1)
    self.assertCurrentView(viewModel: viewModel, view: .loadingView)
    self.assertLines(viewModel: viewModel, lines: [])
  }

  func test_duplicateResponse_data_doesNothing() {
    let state = SearchCardState(page: .tram, selectedLines: self.selectedLines)
    let viewModel = self.createViewModel(state: state)

    viewModel.viewDidLoad()
    self.assertStateAfterViewDidLoad(viewModel: viewModel)

    let lines = self.lines

    self.setLineResponseState(.data(lines))
    XCTAssertEqual(self.refreshCount, 2)
    XCTAssertNil(self.apiErrorAlert)
    XCTAssertEqual(self.dispatchedActions.count, 1)
    self.assertCurrentView(viewModel: viewModel, view: .lineSelector)
    self.assertLines(viewModel: viewModel, lines: lines)

    self.setLineResponseState(.data(lines))
    XCTAssertEqual(self.refreshCount, 2)
    XCTAssertNil(self.apiErrorAlert)
    XCTAssertEqual(self.dispatchedActions.count, 1)
    self.assertCurrentView(viewModel: viewModel, view: .lineSelector)
    self.assertLines(viewModel: viewModel, lines: lines)
  }

  func test_duplicateResponse_error_doesNothing() {
    let apiErrors: [ApiError] = [
      .invalidResponse,
      .reachabilityError,
      .otherError(DummyError())
    ]

    for apiError in apiErrors {
      self.refreshCount = 0
      self.dispatchedActions = []
      self.apiErrorAlert = nil
      self.setLineResponseState(.none)

      // We have to start with some other (non-error) state
      let state = SearchCardState(page: .tram, selectedLines: self.selectedLines)
      let viewModel = self.createViewModel(state: state)

      viewModel.viewDidLoad()
      self.assertStateAfterViewDidLoad(viewModel: viewModel)

      self.setLineResponseState(.error(apiError))
      XCTAssertEqual(self.refreshCount, 1)
      XCTAssertEqual(self.apiErrorAlert, apiError)
      XCTAssertEqual(self.dispatchedActions.count, 1)
      self.assertCurrentView(viewModel: viewModel, view: .loadingView)
      self.assertLines(viewModel: viewModel, lines: [])

      self.apiErrorAlert = nil // Reset to check if we call it again

      self.setLineResponseState(.error(apiError))
      XCTAssertEqual(self.refreshCount, 1)
      XCTAssertNil(self.apiErrorAlert) // Not set again!
      XCTAssertEqual(self.dispatchedActions.count, 1)
      self.assertCurrentView(viewModel: viewModel, view: .loadingView)
      self.assertLines(viewModel: viewModel, lines: [])
    }
  }
}
