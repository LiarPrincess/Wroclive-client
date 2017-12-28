//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import XCTest
import Foundation
import RxSwift
import RxCocoa
import RxTest
@testable import Wroclive

extension LineSelectionViewModelTests {

  // MARK: - Lines changed

  typealias LinesChangedEvent = Recorded<Event<[Line]>>
  typealias LinesEvent        = Recorded<Event<[Line]>>

  func simulateLinesChangedEvents(_ events: LinesChangedEvent...) {
    testScheduler.createHotObservable(events)
      .bind(to: self.viewModel.inputs.linesChanged)
      .disposed(by: self.disposeBag)
  }

  // MARK: - Selected lines changed

  typealias SelectedLinesChangedEvent = Recorded<Event<[Line]>>

  func simulateSelectedLinesChangedEvents(_ events: SelectedLinesChangedEvent...) {
    testScheduler.createHotObservable(events)
      .bind(to: self.viewModel.inputs.selectedLinesChanged)
      .disposed(by: self.disposeBag)
  }

  // MARK: - Equal

  func assertEqual(_ lhs: [LinesEvent], _ rhs: [LinesEvent]) {
    XCTAssertEqual(lhs.count, rhs.count)

    for (lhsEvent, rhsEvent) in zip(lhs, rhs) {
      XCTAssertEqual(lhsEvent.time, rhsEvent.time)

      let lhsElement = lhsEvent.value.element!
      let rhsElement = rhsEvent.value.element!
      XCTAssertEqual(lhsElement, rhsElement)
    }
  }
}
