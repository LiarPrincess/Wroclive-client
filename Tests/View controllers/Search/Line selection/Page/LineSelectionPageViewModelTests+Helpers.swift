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

extension LineSelectionPageViewModelTests {

  // MARK: - Lines changed

  typealias LinesChangedEvent = Recorded<Event<[Line]>>
  typealias SectionEvent      = Recorded<Event<[LineSelectionSection]>>

  func simulateLinesChangedEvents(_ events: LinesChangedEvent...) {
    testScheduler.createHotObservable(events)
      .bind(to: self.viewModel.inputs.linesChanged)
      .disposed(by: self.disposeBag)
  }

  func createSection(subtype lineSubtype: LineSubtype, lines: [Line]) -> LineSelectionSection {
    let data = LineSelectionSectionData(for: lineSubtype)
    return LineSelectionSection(model: data, items: lines.sorted(by: .name))
  }

  func assertEqual(_ lhs: [SectionEvent], _ rhs: [SectionEvent]) {
    XCTAssertEqual(lhs.count, rhs.count)

    for (lhsEvent, rhsEvent) in zip(lhs, rhs) {
      XCTAssertEqual(lhsEvent.time, rhsEvent.time)

      let lhsElement = lhsEvent.value.element!
      let rhsElement = rhsEvent.value.element!
      XCTAssertEqual(lhsElement, rhsElement)
    }
  }

  // MARK: - Selected lines changed

  typealias SelectedLinesChangedEvent = Recorded<Event<[Line]>>

  func simulateSelectedLinesChangedEvents(_ events: SelectedLinesChangedEvent...) {
    testScheduler.createHotObservable(events)
      .bind(to: self.viewModel.inputs.selectedLinesChanged)
      .disposed(by: self.disposeBag)
  }

  func assertEqual(_ lhs: [SelectedLinesChangedEvent], _ rhs: [SelectedLinesChangedEvent]) {
    XCTAssertEqual(lhs.count, rhs.count)

    for (lhsEvent, rhsEvent) in zip(lhs, rhs) {
      XCTAssertEqual(lhsEvent.time, rhsEvent.time)

      let lhsElement = lhsEvent.value.element!
      let rhsElement = rhsEvent.value.element!
      XCTAssertEqual(lhsElement, rhsElement)
    }
  }
}
