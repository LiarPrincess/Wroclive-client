// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import ReSwift
@testable import WrocliveFramework

// swiftlint:disable implicitly_unwrapped_optional

class SearchCardViewModelTests:
  XCTestCase, ReduxTestCase, EnvironmentTestCase, SearchCardViewType {

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

  func createViewModel(state: SearchCardState,
                       response: LineResponse) -> SearchCardViewModel {
    self.storageManager.searchCardState = state
    self.setLineResponseState(response)

    let result = SearchCardViewModel(store: self.store, environment: self.environment)
    result.setView(view: self)
    self.refreshCount = 0
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
}
