// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import Result
import RxSwift
import RxTest
import XCTest
@testable import Wroclive

class VehicleResponseEvent: RecordedEvent<Result<[Vehicle], ApiError>> {
  init(_ time: TestTime, _ vehicles: [Vehicle]) {
    super.init(time, .success(vehicles))
  }

  init(_ time: TestTime, _ error: ApiError) {
    super.init(time, .failure(error))
  }
}

class LiveManagerMock: RxMock, LiveManagerType {

  let scheduler: TestScheduler
  private var _vehicles     = PublishSubject<Result<[Vehicle], ApiError>>()
  private var _trackedLines = [Line]()

  init(_ scheduler: TestScheduler) {
    self.scheduler = scheduler
  }

  // MARK: - LiveManagerType

  private var vehiclesCallCount      = 0
  private var startTrackingCallCount = 0
  private var resumeUpdatesCallCount = 0
  private var pauseUpdatesCallCount  = 0

  var vehicles: ApiResponse<[Vehicle]> {
    self.vehiclesCallCount += 1
    return self._vehicles.asObservable()
  }

  func startTracking(_ lines: [Line]) {
    self.startTrackingCallCount += 1
    self._trackedLines = lines
  }

  func resumeUpdates() { self.resumeUpdatesCallCount += 1 }
  func pauseUpdates()  { self.pauseUpdatesCallCount  += 1 }

  // MARK: - Helpers

  func mockVehicleResponses(_ events: [VehicleResponseEvent]) {
    self.mockEvents(self._vehicles, events)
  }

  func assertOperationCount(vehicles:  Int = 0,
                            file:      StaticString = #file,
                            line:      UInt         = #line) {
    XCTAssertEqual(self.vehiclesCallCount, vehicles, file: file, line: line)
  }

  func assertOperationCount(startTracking:  Int = 0,
                            resumeTracking: Int = 0,
                            pauseTracking:  Int = 0,
                            file:           StaticString = #file,
                            line:           UInt         = #line) {
    XCTAssertEqual(self.startTrackingCallCount, startTracking,  file: file, line: line)
    XCTAssertEqual(self.resumeUpdatesCallCount, resumeTracking, file: file, line: line)
    XCTAssertEqual(self.pauseUpdatesCallCount,  pauseTracking,  file: file, line: line)
  }
}
