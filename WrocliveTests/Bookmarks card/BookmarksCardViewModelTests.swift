// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import ReSwift
@testable import WrocliveFramework

// swiftlint:disable implicitly_unwrapped_optional

class BookmarksCardViewModelTests:
  XCTestCase, ReduxTestCase, EnvironmentTestCase, BookmarksCardViewType {

  var store: Store<AppState>!
  var dispatchedActions: [Action]!
  var environment: Environment!

  var refreshCallCount = 0
  var closeCallCount = 0

  override func setUp() {
    super.setUp()
    self.setUpRedux()
    self.setUpEnvironment()
    self.refreshCallCount = 0
    self.closeCallCount = 0
  }

  // MARK: - View model

  func refresh() {
    self.refreshCallCount += 1
  }

  func close(animated: Bool) {
    self.closeCallCount += 1
  }

  func createViewModel() -> BookmarksCardViewModel {
    let result = BookmarksCardViewModel(store: self.store)
    result.setView(view: self)
    self.refreshCallCount = 0
    return result
  }

  // MARK: - Test data

  lazy var testData: [Bookmark] = {
    let line0 = Line(name: "1", type: .tram, subtype: .regular)
    let line1 = Line(name: "4", type: .tram, subtype: .regular)
    let line2 = Line(name: "20", type: .tram, subtype: .regular)
    let line3 = Line(name: "A", type: .bus, subtype: .regular)
    let line4 = Line(name: "D", type: .bus, subtype: .regular)

    let bookmark0 = Bookmark(name: "Test 0", lines: [line0, line1, line2, line3, line4])
    let bookmark1 = Bookmark(name: "Test 1", lines: [line0, line2, line4])
    let bookmark2 = Bookmark(name: "Test 2", lines: [line0, line2, line3])
    return [bookmark0, bookmark1, bookmark2]
  }()

  // MARK: - Set state

  func setBookmarks(_ bookmarks: [Bookmark]) {
    self.setState { $0.bookmarks = bookmarks }
  }
}
