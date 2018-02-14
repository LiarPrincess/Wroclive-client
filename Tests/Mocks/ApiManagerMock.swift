//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import XCTest
import Foundation
import RxSwift
@testable import Wroclive

// swiftlint:disable implicitly_unwrapped_optional

class ApiManagerMock: ApiManagerType {

  fileprivate var availableLinesCallCount   = 0
  fileprivate var vehicleLocationsCallCount = 0

  var availableLinesValue:   ApiResponse<[Line]>!
  var vehicleLocationsValue: ApiResponse<[Vehicle]>!

  var availableLines: ApiResponse<[Line]> {
    self.availableLinesCallCount += 1
    return self.availableLinesValue
  }

  func vehicleLocations(for lines: [Line]) -> ApiResponse<[Vehicle]> {
    self.vehicleLocationsCallCount += 1
    return self.vehicleLocationsValue
  }
}

func XCTAssertOperationCount(_ manager:        ApiManagerMock,
                             availableLines:   Int = 0,
                             vehicleLocations: Int = 0,
                             file:             StaticString = #file,
                             line:             UInt = #line) {
  XCTAssertEqual(manager.availableLinesCallCount,   availableLines,   file: file, line: line)
  XCTAssertEqual(manager.vehicleLocationsCallCount, vehicleLocations, file: file, line: line)
}
