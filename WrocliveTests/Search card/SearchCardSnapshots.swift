// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import ReSwift
import SnapshotTesting
@testable import WrocliveFramework

// swiftlint:disable implicitly_unwrapped_optional

class SearchCardSnapshots: XCTestCase,
  ReduxTestCase, EnvironmentTestCase, SnapshotTestCase {

  var store: Store<AppState>!
  var dispatchedActions: [Action]!
  var environment: Environment!

  override func setUp() {
    super.setUp()
    self.setUpRedux()
    self.setUpEnvironment()
  }

  // MARK: - Tests

  func test_lines_inProgress() {
    self.onAllDevicesInAllLocales { assertSnapshot in
      self.setLines(state: .inProgress)

      let viewModel = SearchCardViewModel(store: self.store, environment: self.environment)
      let view = SearchCard(viewModel: viewModel)

      assertSnapshot(view, .errorOnThisLine())
    }
  }

  func test_lines() {
    self.onAllDevicesInAllLocales { assertSnapshot in
      self.setLines(lines: self.allLines)
      self.setInitialState(page: .tram, selectedLines: self.selectedLines)

      let viewModel = SearchCardViewModel(store: self.store, environment: self.environment)
      let view = SearchCard(viewModel: viewModel)

      XCTAssertEqual(viewModel.page, .tram)
      assertSnapshot(view, .errorOnThisLine())

      viewModel.viewDidSelectPage(page: .bus)
      assertSnapshot(view, .errorOnThisLine())
    }
  }

  func test_dark() {
    self.inDarkMode { assertSnapshot in
      self.setLines(state: .inProgress)
      self.setInitialState(page: .tram, selectedLines: self.selectedLines)

      let viewModel = SearchCardViewModel(store: self.store, environment: self.environment)
      let view = SearchCard(viewModel: viewModel)

      // lines: inProgress
      assertSnapshot(view, .errorOnThisLine())

      self.setLines(lines: self.allLines)
      XCTAssertEqual(viewModel.page, .tram)
      assertSnapshot(view, .errorOnThisLine())

      viewModel.viewDidSelectPage(page: .bus)
      assertSnapshot(view, .errorOnThisLine())
    }
  }

  // MARK: - Helpers

  private func setLines(state: AppState.ApiResponseState<[Line]>) {
    self.setState { $0.getLinesResponse = state }
  }

  private func setLines(lines: [Line]) {
    self.setLines(state: .data(lines))
  }

  private func setInitialState(page: SearchCardState.Page, selectedLines: [Line]) {
    let state = SearchCardState(page: page, selectedLines: selectedLines)
    self.storageManager.searchCardState = state
  }

  // MARK: - Data

  private lazy var selectedLines = self.allLines
    .enumerated()
    .filter { $0.offset.isMultiple(of: 3) }
    .map { $0.element }

  private let allLines = [
    Line(name: "A", type: .bus, subtype: .express),
    Line(name: "C", type: .bus, subtype: .express),
    Line(name: "D", type: .bus, subtype: .express),
    Line(name: "K", type: .bus, subtype: .express),
    Line(name: "N", type: .bus, subtype: .express),
    Line(name: "0P", type: .tram, subtype: .regular),
    Line(name: "0L", type: .tram, subtype: .regular),
    Line(name: "1", type: .tram, subtype: .regular),
    Line(name: "2", type: .tram, subtype: .regular),
    Line(name: "3", type: .tram, subtype: .regular),
    Line(name: "4", type: .tram, subtype: .regular),
    Line(name: "5", type: .tram, subtype: .regular),
    Line(name: "6", type: .tram, subtype: .regular),
    Line(name: "7", type: .tram, subtype: .regular),
    Line(name: "8", type: .tram, subtype: .regular),
    Line(name: "9", type: .tram, subtype: .regular),
    Line(name: "10", type: .tram, subtype: .regular),
    Line(name: "11", type: .tram, subtype: .regular),
    Line(name: "15", type: .tram, subtype: .regular),
    Line(name: "16", type: .tram, subtype: .regular),
    Line(name: "17", type: .tram, subtype: .regular),
    Line(name: "20", type: .tram, subtype: .regular),
    Line(name: "23", type: .tram, subtype: .regular),
    Line(name: "31", type: .tram, subtype: .regular),
    Line(name: "32", type: .tram, subtype: .regular),
    Line(name: "33", type: .tram, subtype: .regular),
    Line(name: "100", type: .bus, subtype: .regular),
    Line(name: "101", type: .bus, subtype: .regular),
    Line(name: "102", type: .bus, subtype: .regular),
    Line(name: "103", type: .bus, subtype: .regular),
    Line(name: "104", type: .bus, subtype: .regular),
    Line(name: "105", type: .bus, subtype: .regular),
    Line(name: "106", type: .bus, subtype: .regular),
    Line(name: "107", type: .bus, subtype: .regular),
    Line(name: "108", type: .bus, subtype: .regular),
    Line(name: "109", type: .bus, subtype: .regular),
    Line(name: "110", type: .bus, subtype: .regular),
    Line(name: "111", type: .bus, subtype: .regular),
    Line(name: "112", type: .bus, subtype: .regular),
    Line(name: "113", type: .bus, subtype: .regular),
    Line(name: "114", type: .bus, subtype: .regular),
    Line(name: "115", type: .bus, subtype: .regular),
//    Line(name: "116", type: .bus, subtype: .regular),
//    Line(name: "118", type: .bus, subtype: .regular),
//    Line(name: "119", type: .bus, subtype: .regular),
//    Line(name: "120", type: .bus, subtype: .regular),
//    Line(name: "121", type: .bus, subtype: .regular),
//    Line(name: "122", type: .bus, subtype: .regular),
//    Line(name: "124", type: .bus, subtype: .regular),
//    Line(name: "125", type: .bus, subtype: .regular),
//    Line(name: "126", type: .bus, subtype: .regular),
//    Line(name: "127", type: .bus, subtype: .regular),
//    Line(name: "128", type: .bus, subtype: .regular),
//    Line(name: "129", type: .bus, subtype: .regular),
//    Line(name: "130", type: .bus, subtype: .regular),
//    Line(name: "131", type: .bus, subtype: .regular),
//    Line(name: "132", type: .bus, subtype: .regular),
//    Line(name: "133", type: .bus, subtype: .regular),
//    Line(name: "134", type: .bus, subtype: .regular),
//    Line(name: "136", type: .bus, subtype: .regular),
//    Line(name: "140", type: .bus, subtype: .regular),
//    Line(name: "141", type: .bus, subtype: .regular),
//    Line(name: "142", type: .bus, subtype: .regular),
//    Line(name: "143", type: .bus, subtype: .regular),
//    Line(name: "144", type: .bus, subtype: .regular),
//    Line(name: "145", type: .bus, subtype: .regular),
//    Line(name: "146", type: .bus, subtype: .regular),
//    Line(name: "147", type: .bus, subtype: .regular),
//    Line(name: "148", type: .bus, subtype: .regular),
//    Line(name: "149", type: .bus, subtype: .regular),
//    Line(name: "150", type: .bus, subtype: .regular),
//    Line(name: "151", type: .bus, subtype: .regular),
    Line(name: "206", type: .bus, subtype: .night),
    Line(name: "240", type: .bus, subtype: .night),
    Line(name: "241", type: .bus, subtype: .night),
    Line(name: "242", type: .bus, subtype: .night),
    Line(name: "243", type: .bus, subtype: .night),
    Line(name: "245", type: .bus, subtype: .night),
    Line(name: "246", type: .bus, subtype: .night),
    Line(name: "247", type: .bus, subtype: .night),
    Line(name: "248", type: .bus, subtype: .night),
    Line(name: "249", type: .bus, subtype: .night),
    Line(name: "250", type: .bus, subtype: .night),
    Line(name: "251", type: .bus, subtype: .night),
//    Line(name: "253", type: .bus, subtype: .night),
//    Line(name: "255", type: .bus, subtype: .night),
//    Line(name: "257", type: .bus, subtype: .night),
//    Line(name: "259", type: .bus, subtype: .night),
    Line(name: "319", type: .bus, subtype: .regular),
    Line(name: "325", type: .bus, subtype: .regular),
    Line(name: "602", type: .bus, subtype: .suburban),
    Line(name: "607", type: .bus, subtype: .suburban),
    Line(name: "609", type: .bus, subtype: .suburban),
    Line(name: "612", type: .bus, subtype: .suburban),
    Line(name: "701", type: .bus, subtype: .temporary),
    Line(name: "714", type: .bus, subtype: .temporary),
    Line(name: "715", type: .bus, subtype: .temporary),
    Line(name: "720", type: .bus, subtype: .temporary)
  ]
}
