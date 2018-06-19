//
//  Created by Michal Matuszczyk
//  Copyright © 2018 Michal Matuszczyk. All rights reserved.
//

import XCTest
import Result
import RxSwift
import RxCocoa
import RxTest
import RxBlocking
@testable import Wroclive

class SearchCardViewModelTrackingTests: SearchCardViewModelTestsBase {

  func test_search_startsTracking() {
    let lines = self.testLines
    self.storageManager._searchCardState = SearchCardState(page: .tram, selectedLines: lines)
    self.viewModel = SearchCardViewModel()

    self.simulateSearchButtonPressedEvents(at: 100)

    let observer = self.testScheduler.createObserver([Line].self)
    self.viewModel.startTracking
      .drive(observer)
      .disposed(by: self.disposeBag)
    self.testScheduler.start()

    XCTAssertEqual(observer.events, [next(100, lines)])
  }
}
