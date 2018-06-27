// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import Foundation
import RxSwift
import RxTest
@testable import Wroclive

// swiftlint:disable identifier_name

class ApiManagerMock: RxMock, ApiManagerType {

  let scheduler: TestScheduler

  fileprivate var availableLinesCallCount   = 0
  fileprivate var vehicleLocationsCallCount = 0

  init(_ scheduler: TestScheduler) {
    self.scheduler = scheduler
  }

  // MARK: - Lines

  private var _availableLineResponses = [TestTime:Single<[Line]>]()

  var availableLines: Single<[Line]> {
    self.availableLinesCallCount += 1
    return self.current(from: self._availableLineResponses)
  }

  func mockAvailableLineResponse(at time: TestTime, _ value: Single<[Line]>) {
    self.schedule(at: time, value, in: &self._availableLineResponses)
  }

  // MARK: - Vehicles

  func vehicleLocations(for lines: [Line]) -> Single<[Vehicle]> {
    return .never()
  }

  // MARK: - Helpers

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
