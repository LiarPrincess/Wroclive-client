//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

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

  private let disposeBag = DisposeBag()

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
