// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import WrocliveFramework

private typealias Constants = BookmarksCard.Constants.Header.Edit
private typealias Localization = Localizable.Bookmarks.Edit

private let doneAttributes = Constants.doneAttributes
private let editAttributes = Constants.editAttributes

extension BookmarksCardViewModelTests {

  func test_editButton_changesIsEditing() {
    let viewModel = self.createViewModel()
    XCTAssertFalse(viewModel.isEditing)
    XCTAssertEqual(self.refreshCallCount, 0)

    viewModel.viewDidPressEditButton()
    XCTAssertTrue(viewModel.isEditing)
    XCTAssertEqual(self.refreshCallCount, 1)

    viewModel.viewDidPressEditButton()
    XCTAssertFalse(viewModel.isEditing)
    XCTAssertEqual(self.refreshCallCount, 2)
  }

  func test_editButton_updatesEditButtonText() {
    let viewModel = self.createViewModel()
    XCTAssertEqual(self.refreshCallCount, 0)
    XCTAssertEqual(
      viewModel.editButtonText,
      NSAttributedString(string: Localization.edit, attributes: editAttributes)
    )

    viewModel.viewDidPressEditButton()
    XCTAssertEqual(self.refreshCallCount, 1)
    XCTAssertEqual(
      viewModel.editButtonText,
      NSAttributedString(string: Localization.done, attributes: doneAttributes)
    )

    viewModel.viewDidPressEditButton()
    XCTAssertEqual(self.refreshCallCount, 2)
    XCTAssertEqual(
      viewModel.editButtonText,
      NSAttributedString(string: Localization.edit, attributes: editAttributes)
    )
  }
}
