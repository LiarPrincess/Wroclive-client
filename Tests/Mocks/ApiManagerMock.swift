// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import Foundation
import RxSwift
import RxTest
@testable import Wroclive

// swiftlint:disable identifier_name

class LinesResponseEvent: RecordedEvent<Event<[Line]>> {
  init(_ time: TestTime, _ data: [Line]) {
    super.init(time, .next(data))
  }

  init(_ time: TestTime, _ error: Error) {
    super.init(time, .error(error))
  }
}

class ApiManagerMock: RxMock, ApiManagerType {

  let scheduler: TestScheduler
  let _availableLines   = PublishSubject<[Line]>()
  let _vehicleLocations = PublishSubject<[Vehicle]>()

  init(_ scheduler: TestScheduler) {
    self.scheduler = scheduler
  }

  // MARK: - ApiManagerType

  fileprivate var availableLinesCallCount   = 0
  fileprivate var vehicleLocationsCallCount = 0

  var availableLines: Observable<[Line]> {
    self.availableLinesCallCount += 1
    return self._availableLines.asObservable()
  }

  func vehicleLocations(for lines: [Line]) -> Observable<[Vehicle]> {
    self.vehicleLocationsCallCount += 1
    return self._vehicleLocations.asObservable()
  }

  // MARK: - Helpers

  func mockLineResponses(_ events: [LinesResponseEvent]) {
//    self.mockEvents(self._vehicles, events)
  }

  func assertOperationCount(availableLines: Int,
                            file:           StaticString = #file,
                            line:           UInt         = #line) {
    XCTAssertEqual(self.availableLinesCallCount, availableLines, file: file, line: line)
  }

  func assertOperationCount(vehicleLocations: Int,
                            file:             StaticString = #file,
                            line:             UInt         = #line) {
    XCTAssertEqual(self.vehicleLocationsCallCount, vehicleLocations, file: file, line: line)
  }
}
