// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import Foundation
import Result
import RxSwift
import RxTest
@testable import Wroclive

// swiftlint:disable identifier_name

class ApiManagerMock: ApiManagerType {

  fileprivate var availableLinesCallCount   = 0
  fileprivate var vehicleLocationsCallCount = 0

  let _availableLines   = ReplaySubject<Result<[Line],    ApiError>>.create(bufferSize: 1)
  let _vehicleLocations = ReplaySubject<Result<[Vehicle], ApiError>>.create(bufferSize: 1)

  var availableLines: ApiResponse<[Line]> {
    self.availableLinesCallCount += 1
    return self._availableLines.share(replay: 1)
  }

  func vehicleLocations(for lines: [Line]) -> ApiResponse<[Vehicle]> {
    self.vehicleLocationsCallCount += 1
    return self._vehicleLocations.share(replay: 1)
  }
}

func XCTAssertOperationCount(_ manager:        ApiManagerMock,
                             availableLines:   Int = 0,
                             vehicleLocations: Int = 0,
                             file:             StaticString = #file,
                             line:             UInt         = #line) {
  XCTAssertEqual(manager.availableLinesCallCount,   availableLines,   file: file, line: line)
  XCTAssertEqual(manager.vehicleLocationsCallCount, vehicleLocations, file: file, line: line)
}
