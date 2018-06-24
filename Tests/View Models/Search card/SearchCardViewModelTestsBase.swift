// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import RxSwift
import RxCocoa
import RxTest
@testable import Wroclive

// swiftlint:disable implicitly_unwrapped_optional

private typealias TextStyles = LineSelectorCellConstants.TextStyles

class SearchCardViewModelTestsBase: TestCase {

  var viewModel: SearchCardViewModel!

  // MARK: - Test data

  var testLines: [Line] {
    let line0 = Line(name:  "1", type: .tram, subtype: .regular)
    let line1 = Line(name:  "4", type: .tram, subtype: .regular)
    let line2 = Line(name: "20", type: .tram, subtype: .regular)
    let line3 = Line(name:  "A", type:  .bus, subtype: .regular)
    let line4 = Line(name:  "D", type:  .bus, subtype: .regular)
    return [line0, line1, line2, line3, line4]
  }

  // MARK: - Events

  typealias PageSelectedEvent      = Recorded<Event<LineType>>
  typealias PageDidTransitionEvent = Recorded<Event<LineType>>

  func simulatePageSelectedEvents(_ events: PageSelectedEvent...) {
    self.scheduler.createHotObservable(events)
      .bind(to: self.viewModel.didSelectPage)
      .disposed(by: self.disposeBag)
  }

  func simulatePageDidTransitionEvents(_ events: PageDidTransitionEvent...) {
    self.scheduler.createHotObservable(events)
      .bind(to: self.viewModel.didTransitionToPage)
      .disposed(by: self.disposeBag)
  }

  func mockLineResponses(_ events: LinesResponseEvent...) {
    self.apiManager.mockLineResponses(events)
  }

  func simulateTryAgainButtonPressedEvents(at times: TestTime...) {
    let events = times.map { next($0, ()) }
    self.scheduler.createHotObservable(events)
      .bind(to: self.viewModel.didPressAlertTryAgainButton)
      .disposed(by: self.disposeBag)
  }

  typealias LineSelectedEvent   = Recorded<Event<Line>>
  typealias LineDeselectedEvent = Recorded<Event<Line>>

  func simulateLineSelectedEvents(_ events: LineSelectedEvent...) {
    self.scheduler.createHotObservable(events)
      .bind(to: self.viewModel.didSelectLine)
      .disposed(by: self.disposeBag)
  }

  func simulateLineDeselectedEvents(_ events: LineDeselectedEvent...) {
    self.scheduler.createHotObservable(events)
      .bind(to: self.viewModel.didDeselectLine)
      .disposed(by: self.disposeBag)
  }

  func simulateBookmarkButtonPressedEvents(at times: TestTime...) {
    let events = times.map { next($0, ()) }
    self.scheduler.createHotObservable(events)
      .bind(to: self.viewModel.didPressBookmarkButton)
      .disposed(by: self.disposeBag)
  }

  typealias NameEnteredEvent = Recorded<Event<String>>

  func simulateBookmarkAlertNameEnteredEvents(_ events: NameEnteredEvent...) {
    self.scheduler.createHotObservable(events)
      .bind(to: self.viewModel.didEnterBookmarkName)
      .disposed(by: self.disposeBag)
  }

  func simulateSearchButtonPressedEvents(at times: TestTime...) {
    let events = times.map { next($0, ()) }
    self.scheduler.createHotObservable(events)
      .bind(to: self.viewModel.didPressSearchButton)
      .disposed(by: self.disposeBag)
  }

  func simulateViewDidAppearEvents(at times: TestTime...) {
    let events = times.map { next($0, ()) }
    self.scheduler.createHotObservable(events)
      .bind(to: self.viewModel.viewDidAppear)
      .disposed(by: self.disposeBag)
  }

  func simulateViewDidDisappearEvents(at times: TestTime...) {
    let events = times.map { next($0, ()) }
    self.scheduler.createHotObservable(events)
      .bind(to: self.viewModel.viewDidDisappear)
      .disposed(by: self.disposeBag)
  }
}

func XCTAssertEqual(_ lhs: [Recorded<Event<SearchCardAlert>>],
                    _ rhs: [Recorded<Event<SearchCardAlert>>],
                    file: StaticString = #file,
                    line: UInt = #line) {
  XCTAssertEqual(lhs.count, rhs.count, file: file, line: line)

  for (lhsEvent, rhsEvent) in zip(lhs, rhs) {
    XCTAssertEqual(lhsEvent.time, rhsEvent.time, file: file, line: line)

    let lhsAlert = lhsEvent.value.element!
    let rhsAlert = rhsEvent.value.element!

    switch (lhsAlert, rhsAlert) {
    case (.bookmarkNameInput, .bookmarkNameInput): break
    case (.bookmarkNoLineSelected, .bookmarkNoLineSelected): break
    case let (.apiError(error1), .apiError(error2)): XCTAssertEqual(error1, error2)
    default:
      XCTAssertTrue(false, "Alerts \(lhsAlert) and \(rhsAlert) are not equal.", file: file, line: line)
    }
  }
}
