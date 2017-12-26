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

  typealias BookmarkEvent = Recorded<Event<Bookmark>>

  func simulateBookmarkEvents(_ events: BookmarkEvent...) {
    testScheduler.createHotObservable(events)
      .bind(to: self.viewModel.inputs.bookmark)
      .disposed(by: self.disposeBag)
  }
}
