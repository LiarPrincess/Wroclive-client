// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import RxSwift
import RxCocoa
import RxTest
@testable import WrocliveFramework

extension SearchCardViewModelTests {

  func test_beforeAppearing_dispatchesUpdateLinesAction() {
    self.viewWillAppear(at: 100)
    self.startScheduler()

    XCTAssertEqual(self.dispatchedActions.count, 1)
    XCTAssertTrue(self.isApiUpdateLinesAction(at: 0))
  }

  func test_pressingTryAgainButton_dispatchesUpdateLinesAction() {
    self.didPressAlertTryAgainButton(at: 100)
    self.startScheduler()

    XCTAssertEqual(self.dispatchedActions.count, 1)
    XCTAssertTrue(self.isApiUpdateLinesAction(at: 0))
  }

  func test_withLineResponse_updatesLines() {
    self.viewWillAppear(at: 100)
    self.setLineResponseState(at: 100, .inProgress)
    self.setLineResponseState(at: 200, .inProgress) // we should skip this one as it is the same as previous
    self.setLineResponseState(at: 300, .data(self.testLines))
    self.setLineResponseState(at: 400, .data(self.testLines))
    self.startScheduler()

    let linesObserverEvents = self.linesObserver.events
    if XCTIfEqual(linesObserverEvents.count, 2) {
      XCTAssertEqual(linesObserverEvents[0], Recorded.next(0, []))
      XCTAssertEqual(linesObserverEvents[1].time, 300) // we cannot assume particular grouping
      XCTAssertEqual(linesObserverEvents[1].value.element!.count, self.testLines.count)
    }

    XCTAssertEqual(self.showAlertObserver.events, [])

    let isLineSelectorVisible = [Recorded.next(0, false), Recorded.next(300, true)]
    XCTAssertEqual(self.isLineSelectorVisibleObserver.events, isLineSelectorVisible)
    XCTAssertEqual(self.isPlaceholderVisibleObserver.events,  isLineSelectorVisible.opposite())
  }

  func test_withLineResponse_withoutLines_showsAlert() {
    self.viewWillAppear(at: 100)
    self.setLineResponseState(at: 100, .inProgress)
    self.setLineResponseState(at: 200, .inProgress) // we should skip this one as it is the same as previous
    self.setLineResponseState(at: 300, .data([]))
    self.setLineResponseState(at: 400, .data([]))
    self.startScheduler()

    XCTAssertEqual(self.linesObserver.events,     [Recorded.next(0, [])])
    XCTAssertEqual(self.showAlertObserver.events, [Recorded.next(300, .apiError(.generalError))])

    let isLineSelectorVisible = [Recorded.next(0, false)]
    XCTAssertEqual(self.isLineSelectorVisibleObserver.events, isLineSelectorVisible)
    XCTAssertEqual(self.isPlaceholderVisibleObserver.events,  isLineSelectorVisible.opposite())
  }

  func test_withLineResponseError_thenRetry_thenLineResponse_updatesLines() {
    self.viewWillAppear(at: 100)
    self.setLineResponseState(at: 100, .error(ApiError.generalError))
    self.didPressAlertTryAgainButton(at: 200)
    self.setLineResponseState(at: 300, .inProgress)
    self.setLineResponseState(at: 400, .data(self.testLines))
    self.setLineResponseState(at: 500, .data(self.testLines)) // we should skip this one as it is the same as previous
    self.startScheduler()

    let linesObserverEvents = self.linesObserver.events
    if XCTIfEqual(linesObserverEvents.count, 2) {
      XCTAssertEqual(linesObserverEvents[0], Recorded.next(0, []))
      XCTAssertEqual(linesObserverEvents[1].time, 400) // we cannot assume particular grouping
      XCTAssertEqual(linesObserverEvents[1].value.element!.count, self.testLines.count)
    }

    XCTAssertEqual(self.showAlertObserver.events, [Recorded.next(100, .apiError(.generalError))])

    let isLineSelectorVisible = [Recorded.next(0, false), Recorded.next(400, true)]
    XCTAssertEqual(self.isLineSelectorVisibleObserver.events, isLineSelectorVisible)
    XCTAssertEqual(self.isPlaceholderVisibleObserver.events,  isLineSelectorVisible.opposite())
  }

  func test_withLineResponseError_thenRetry_thenApiError_showsAlerts() {
    self.viewWillAppear(at: 100)
    self.setLineResponseState(at: 100, .error(ApiError.generalError))
    self.didPressAlertTryAgainButton(at: 200)
    self.setLineResponseState(at: 300, .inProgress)
    self.setLineResponseState(at: 400, .error(ApiError.noInternet))
    self.setLineResponseState(at: 500, .error(ApiError.noInternet)) // we should skip this one as it is the same as previous
    self.startScheduler()

    XCTAssertEqual(self.linesObserver.events, [Recorded.next(0, [])])

    let alertEvents = self.showAlertObserver.events
    if XCTIfEqual(alertEvents.count, 2) {
      XCTAssertEqual(alertEvents[0], Recorded.next(100, .apiError(.generalError)))
      XCTAssertEqual(alertEvents[1], Recorded.next(400, .apiError(.noInternet)))
    }

    let isLineSelectorVisible = [Recorded.next(0, false)]
    XCTAssertEqual(self.isLineSelectorVisibleObserver.events, isLineSelectorVisible)
    XCTAssertEqual(self.isPlaceholderVisibleObserver.events,  isLineSelectorVisible.opposite())
  }
}

private extension Array where Element == Recorded<Event<Bool>> {
  func opposite() -> [Recorded<Event<Bool>>] {
    return self.map { event in
      let value = event.value.element!
      return Recorded.next(event.time, !value)
    }
  }
}
