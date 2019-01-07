// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import RxSwift
import RxCocoa
import RxTest
@testable import WrocliveFramework

extension SearchCardViewModelTests {

  func test_afterLoadingView_dispatchesUpdateLinesAction() {
    self.initViewModel()
    self.mockViewDidLoad(at: 100)
    self.startScheduler()

    XCTAssertEqual(self.dispatchedActions.count, 1)
    XCTAssertTrue(self.isApiUpdateLinesAction(at: 0))
  }

  func test_withLineResponse_updatesLines() {
    self.initViewModel()
    self.mockLineResponse(at: 100, .inProgress)
    self.mockLineResponse(at: 200, .inProgress) // we should skip this one as it is the same as previous
    self.mockLineResponse(at: 300, .data(self.testLines))
    self.mockLineResponse(at: 400, .data(self.testLines))
    self.startScheduler()

    XCTAssertEqual(self.linesObserver.events, [Recorded.next(0, []), Recorded.next(300, self.testLines)])
    XCTAssertEqual(self.showAlertObserver.events, [])

    let isLineSelectorVisible = [Recorded.next(0, false), Recorded.next(300, true)]
    XCTAssertEqual(self.isLineSelectorVisibleObserver.events, isLineSelectorVisible)
    XCTAssertEqual(self.isPlaceholderVisibleObserver.events,  isLineSelectorVisible.opposite())
  }

  func test_withLineResponse_withoutLines_showsAlert() {
    self.initViewModel()
    self.mockLineResponse(at: 100, .inProgress)
    self.mockLineResponse(at: 200, .inProgress) // we should skip this one as it is the same as previous
    self.mockLineResponse(at: 300, .data([]))
    self.mockLineResponse(at: 400, .data([]))
    self.startScheduler()

    XCTAssertEqual(self.linesObserver.events,     [Recorded.next(0, [])])
    XCTAssertEqual(self.showAlertObserver.events, [Recorded.next(300, .apiError(.generalError))])

    let isLineSelectorVisible = [Recorded.next(0, false)]
    XCTAssertEqual(self.isLineSelectorVisibleObserver.events, isLineSelectorVisible)
    XCTAssertEqual(self.isPlaceholderVisibleObserver.events,  isLineSelectorVisible.opposite())
  }

  func test_withLineResponseError_thenRetry_thenLineResponse_updatesLines() {
    self.initViewModel()
    self.mockLineResponse(at: 100, .error(ApiError.generalError))
    self.mockTryAgainButtonPressed(at: 200)
    self.mockLineResponse(at: 300, .inProgress)
    self.mockLineResponse(at: 400, .data(self.testLines))
    self.mockLineResponse(at: 500, .data(self.testLines)) // we should skip this one as it is the same as previous
    self.startScheduler()

    XCTAssertEqual(self.linesObserver.events,     [Recorded.next(0, []), Recorded.next(400, self.testLines)])
    XCTAssertEqual(self.showAlertObserver.events, [Recorded.next(100, .apiError(.generalError))])

    let isLineSelectorVisible = [Recorded.next(0, false), Recorded.next(400, true)]
    XCTAssertEqual(self.isLineSelectorVisibleObserver.events, isLineSelectorVisible)
    XCTAssertEqual(self.isPlaceholderVisibleObserver.events,  isLineSelectorVisible.opposite())
  }

  func test_withLineResponseError_thenRetry_thenApiError_showsAlerts() {
    self.initViewModel()
    self.mockLineResponse(at: 100, .error(ApiError.generalError))
    self.mockTryAgainButtonPressed(at: 200)
    self.mockLineResponse(at: 300, .inProgress)
    self.mockLineResponse(at: 400, .error(ApiError.noInternet))
    self.mockLineResponse(at: 500, .error(ApiError.noInternet)) // we should skip this one as it is the same as previous
    self.startScheduler()

    XCTAssertEqual(self.linesObserver.events, [Recorded.next(0, [])])

    XCTAssertEqual(self.showAlertObserver.events, [
    next(100, .apiError(.generalError)),
    next(400, .apiError(.noInternet))
    ])

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
