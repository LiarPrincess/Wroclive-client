// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import RxSwift
import RxCocoa
import RxTest
@testable import Wroclive

private typealias TextStyles   = BookmarksCardConstants.TextStyles.Edit
private typealias Localization = Localizable.Bookmarks.Edit

extension BookmarksCardViewModelTests {

  func test_editButton_changesIsEditing() {
    self.viewModel = BookmarksCardViewModel()
    self.simulateEditClickEvents(at: 100, 200)

    let observer = self.scheduler.createObserver(Bool.self)
    viewModel.isEditing
      .drive(observer)
      .disposed(by: self.disposeBag)
    self.startScheduler()

    let expectedEvents = [next(0, false), next(100, true), next(200, false)]
    XCTAssertEqual(observer.events, expectedEvents)
  }

  func test_editButton_updatesEditButtonText() {
    self.viewModel = BookmarksCardViewModel()
    self.simulateEditClickEvents(at: 100, 200)

    let observer = self.scheduler.createObserver(NSAttributedString.self)
    viewModel.editButtonText
      .drive(observer)
      .disposed(by: self.disposeBag)
    self.startScheduler()

    let expectedEvents = [
      next(  0, NSAttributedString(string: Localization.edit, attributes: TextStyles.edit)),
      next(100, NSAttributedString(string: Localization.done, attributes: TextStyles.done)),
      next(200, NSAttributedString(string: Localization.edit, attributes: TextStyles.edit))
    ]
    XCTAssertEqual(observer.events, expectedEvents)
  }
}
