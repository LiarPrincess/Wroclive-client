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

extension SearchCardViewModelTests {

  // MARK: - Page

  typealias PageSelectedEvent      = Recorded<Event<LineType>>
  typealias PageDidTransitionEvent = Recorded<Event<LineType>>

  func simulatePageSelectedEvents(_ events: PageSelectedEvent...) {
    testScheduler.createHotObservable(events)
      .bind(to: self.viewModel.inputs.pageSelected)
      .disposed(by: self.disposeBag)
  }

  func simulatePageDidTransitionEvents(_ events: PageDidTransitionEvent...) {
    testScheduler.createHotObservable(events)
      .bind(to: self.viewModel.inputs.pageDidTransition)
      .disposed(by: self.disposeBag)
  }

  // MARK: - Buttons

  func simulateBookmarkButtonPressedEvents(at times: TestTime...) {
    let events = times.map { next($0, ()) }
    testScheduler.createHotObservable(events)
      .bind(to: self.viewModel.inputs.bookmarkButtonPressed)
      .disposed(by: self.disposeBag)
  }

  func simulateSearchButtonPressedEvents(at times: TestTime...) {
    let events = times.map { next($0, ()) }
    testScheduler.createHotObservable(events)
      .bind(to: self.viewModel.inputs.searchButtonPressed)
      .disposed(by: self.disposeBag)
  }

  // MARK: - Alerts

  func simulateApiAlertTryAgainButtonPressedEvents(at times: TestTime...) {
    let events = times.map { next($0, ()) }
    testScheduler.createHotObservable(events)
      .bind(to: self.viewModel.inputs.apiAlertTryAgainButtonPressed)
      .disposed(by: self.disposeBag)
  }

  // MARK: - View controller lifecycle

  func simulateViewDidAppearEvents(at times: TestTime...) {
    let events = times.map { next($0, ()) }
    testScheduler.createHotObservable(events)
      .bind(to: self.viewModel.inputs.viewDidAppear)
      .disposed(by: self.disposeBag)
  }

  func simulateViewDidDisappearEvents(at times: TestTime...) {
    let events = times.map { next($0, ()) }
    testScheduler.createHotObservable(events)
      .bind(to: self.viewModel.inputs.viewDidDisappear)
      .disposed(by: self.disposeBag)
  }

  // MARK: - Asserts

  typealias VoidEvent = Recorded<Event<Void>>

  func assertSearchOperationCount(get: Int, save: Int) {
    XCTAssertEqual(self.searchManager.getStateCount, get)
    XCTAssertEqual(self.searchManager.saveCount, save)
  }

  func assertEqual(_ lhs: [VoidEvent], _ rhs: [VoidEvent]) {
    XCTAssertEqual(lhs.count, rhs.count)

    for (lhsEvent, rhsEvent) in zip(lhs, rhs) {
      XCTAssertEqual(lhsEvent.time, rhsEvent.time)
    }
  }
}
