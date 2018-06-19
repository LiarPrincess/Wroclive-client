//
//  Created by Michal Matuszczyk
//  Copyright © 2018 Michal Matuszczyk. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
@testable import Wroclive

private typealias TextStyles   = BookmarksCardConstants.TextStyles.Edit
private typealias Localization = Localizable.Bookmarks.Edit

class BookmarksCardViewModelEditTests: BookmarksCardViewModelTestsBase {

  func test_editButton_changesIsEditing() {
    self.viewModel = BookmarksCardViewModel()
    self.simulateEditClickEvents(at: 100, 200)

    let observer = self.testScheduler.createObserver(Bool.self)
    viewModel.isEditing
      .drive(observer)
      .disposed(by: self.disposeBag)
    self.testScheduler.start()

    let expectedEvents = [next(0, false), next(100, true), next(200, false)]
    XCTAssertEqual(observer.events, expectedEvents)
  }

  func test_editButton_updatesEditButtonText() {
    self.viewModel = BookmarksCardViewModel()
    self.simulateEditClickEvents(at: 100, 200)

    let observer = self.testScheduler.createObserver(NSAttributedString.self)
    viewModel.editButtonText
      .drive(observer)
      .disposed(by: self.disposeBag)
    self.testScheduler.start()

    let expectedEvents = [
      next(  0, NSAttributedString(string: Localization.edit, attributes: TextStyles.edit)),
      next(100, NSAttributedString(string: Localization.done, attributes: TextStyles.done)),
      next(200, NSAttributedString(string: Localization.edit, attributes: TextStyles.edit))
    ]
    XCTAssertEqual(observer.events, expectedEvents)
  }
}
