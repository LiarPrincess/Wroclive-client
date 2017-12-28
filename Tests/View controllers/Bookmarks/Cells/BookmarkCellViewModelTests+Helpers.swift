//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
@testable import Wroclive

extension BookmarkCellViewModelTests {

  // MARK: - Bookmark

  typealias BookmarkChangedEvent = Recorded<Event<Bookmark>>

  func simulateBookmarkEvents(_ events: BookmarkChangedEvent...) {
    testScheduler.createHotObservable(events)
      .bind(to: self.viewModel.inputs.bookmarkChanged)
      .disposed(by: self.disposeBag)
  }
}
