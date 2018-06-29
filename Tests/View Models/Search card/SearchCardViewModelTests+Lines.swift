// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import RxSwift
import RxCocoa
import RxTest
@testable import Wroclive

extension SearchCardViewModelTests {

  /**
   Steps:
   100 View did appear
   100 Request lines
   150 Line response
   150 Show lines, hide placeholder
   */
  func test_didAppear_withLineResponse_updatesLines() {
    self.initViewModel()

    let lines = self.testData
    self.mockViewDidAppear(at: 100)
    self.mockLineResponse(at: 100, Single.just(lines).delay(50, scheduler: self.scheduler))

    self.startScheduler()

    XCTAssertEqual(self.linesObserver.events,     [Recorded.next(0, []), Recorded.next(150, lines)])
    XCTAssertEqual(self.showAlertObserver.events, [])

    let isLineSelectorVisible = [Recorded.next(0, false), Recorded.next(150, true)]
    XCTAssertEqual(self.isLineSelectorVisibleObserver.events, isLineSelectorVisible)
    XCTAssertEqual(self.isPlaceholderVisibleObserver.events,  self.opposite(isLineSelectorVisible))

    self.apiManager.assertOperationCount(availableLines: 1)
  }

  /**
   Steps:
   100 View did appear
   100 Request lines
   150 Line response without lines
   150 Show error, preserve placeholder
   */
  func test_didAppear_withLineResponse_withoutLines_showsAlert() {
    self.initViewModel()

    let lines = [Line]()
    self.mockViewDidAppear(at: 100)
    self.mockLineResponse(at: 100, Single.just(lines).delay(50, scheduler: self.scheduler))

    self.startScheduler()

    XCTAssertEqual(self.linesObserver.events,     [Recorded.next(0, [])])
    XCTAssertEqual(self.showAlertObserver.events, [Recorded.next(150, .apiError(.generalError))])

    let isLineSelectorVisible = [Recorded.next(0, false)]
    XCTAssertEqual(self.isLineSelectorVisibleObserver.events, isLineSelectorVisible)
    XCTAssertEqual(self.isPlaceholderVisibleObserver.events,  self.opposite(isLineSelectorVisible))

    self.apiManager.assertOperationCount(availableLines: 1)
  }

  /**
   Steps:
   100 View did appear
   100 Request lines
   100 ApiError
   100 Show error, preserve placeholder
   200 Tap 'try again'
   250 Line response
   250 Show lines, hide placeholder
   */
  func test_didAppear_withApiError_thenRetry_withLineResponse_updatesLines() {
    self.initViewModel()

    let lines = self.testData
    self.mockViewDidAppear(at: 100)
    self.mockLineResponse(at: 100, Single.error(ApiError.generalError))
    self.mockTryAgainButtonPressed(at: 200)
    self.mockLineResponse(at: 200, Single.just(lines).delay(50, scheduler: self.scheduler))

    self.startScheduler()

    XCTAssertEqual(self.linesObserver.events,     [Recorded.next(0, []), Recorded.next(250, lines)])
    XCTAssertEqual(self.showAlertObserver.events, [Recorded.next(100, .apiError(.generalError))])

    let isLineSelectorVisible = [Recorded.next(0, false), Recorded.next(250, true)]
    XCTAssertEqual(self.isLineSelectorVisibleObserver.events, isLineSelectorVisible)
    XCTAssertEqual(self.isPlaceholderVisibleObserver.events,  self.opposite(isLineSelectorVisible))

    self.apiManager.assertOperationCount(availableLines: 2)
  }

  /**
   Steps:
   100 View did appear
   100 Request lines
   100 ApiError
   100 Show error, preserve placeholder
   200 Tap 'try again'
   200 ApiError
   200 Show error, preserve placeholder
   */
  func test_didAppear_withApiError_thenRetry_withApiError_showsAlerts() {
    self.initViewModel()

    self.mockViewDidAppear(at: 100)
    self.mockLineResponse(at: 100, Single.error(ApiError.generalError))
    self.mockTryAgainButtonPressed(at: 200)
    self.mockLineResponse(at: 200, Single.error(ApiError.noInternet))

    self.startScheduler()

    XCTAssertEqual(self.linesObserver.events, [Recorded.next(0, [])])

    XCTAssertEqual(self.showAlertObserver.events, [
      next(100, .apiError(.generalError)),
      next(200, .apiError(.noInternet))
    ])

    let isLineSelectorVisible = [Recorded.next(0, false)]
    XCTAssertEqual(self.isLineSelectorVisibleObserver.events, isLineSelectorVisible)
    XCTAssertEqual(self.isPlaceholderVisibleObserver.events,  self.opposite(isLineSelectorVisible))

    self.apiManager.assertOperationCount(availableLines: 2)
  }

  private func opposite(_ events: [Recorded<Event<Bool>>]) -> [Recorded<Event<Bool>>] {
    return events.map { event in
      let value = event.value.element!
      return Recorded.next(event.time, !value)
    }
  }
}
