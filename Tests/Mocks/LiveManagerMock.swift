// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import Foundation
import RxSwift
import RxTest
@testable import Wroclive

class LiveManagerMock: RxMock, LiveManagerType {

  let scheduler: TestScheduler

  private var vehiclesCallCount      = 0
  private var startTrackingCallCount = 0
  private var resumeUpdatesCallCount = 0
  private var pauseUpdatesCallCount  = 0

  init(_ scheduler: TestScheduler) {
    self.scheduler = scheduler
  }

  // MARK: - Vehicles

  private var _vehicles = PublishSubject<Event<[Vehicle]>>()

  var vehicles: Observable<Event<[Vehicle]>> {
    self.vehiclesCallCount += 1
    return self._vehicles.asObservable()
  }

  func mockVehicleResponse(at time: TestTime, _ value: Event<[Vehicle]>) {
    self.mockNext(self._vehicles, at: time, element: value)
  }

  // MARK: - Start, stop, pause

  private var _trackedLines = [Line]()

  func startTracking(_ lines: [Line]) {
    self.startTrackingCallCount += 1
    self._trackedLines = lines
  }

  func resumeUpdates() { self.resumeUpdatesCallCount += 1 }
  func pauseUpdates()  { self.pauseUpdatesCallCount  += 1 }

  // MARK: - Asserts

  func assertOperationCount(vehicles: Int,
                            file:     StaticString = #file,
                            line:     UInt         = #line) {
    XCTAssertEqual(self.vehiclesCallCount, vehicles, file: file, line: line)
  }

  func assertTrackingOperationCount(start:  Int,
                                    resume: Int,
                                    pause:  Int,
                                    file:   StaticString = #file,
                                    line:   UInt         = #line) {
    XCTAssertEqual(self.startTrackingCallCount, start,  file: file, line: line)
    XCTAssertEqual(self.resumeUpdatesCallCount, resume, file: file, line: line)
    XCTAssertEqual(self.pauseUpdatesCallCount,  pause,  file: file, line: line)
  }
}
