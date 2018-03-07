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
// swiftlint:disable implicitly_unwrapped_optional

class MapManagerMock: MapManagerType {

  // MARK: - Map type

  fileprivate var mapTypeCallCount    = 0
  fileprivate var setMapTypeCallCount = 0

  var _mapType: TestableObservable<MapType>!

  var mapType: Observable<MapType> {
    self.mapTypeCallCount += 1
    return self._mapType.asObservable()
  }

  func setMapType(_ mapType: MapType) {
    self.setMapTypeCallCount += 1
  }

  // MARK: - Tracking

  fileprivate var vehicleLocationsCallCount  = 0
  fileprivate var startTrackingCallCount     = 0
  fileprivate var resumeTrackingCallCount    = 0
  fileprivate var pauseTrackingCallCount     = 0

  var _vehicleLocations: TestableObservable<Result<[Vehicle], ApiError>>!
  private(set) var _trackedLines = [Line]()

  var vehicleLocations: ApiResponse<[Vehicle]> {
    self.vehicleLocationsCallCount += 1
    return self._vehicleLocations.asObservable()
  }

  func startTracking(_ lines: [Line]) {
    self.startTrackingCallCount += 1
    self._trackedLines = lines
  }

  func resumeTracking() { self.resumeTrackingCallCount += 1 }
  func pauseTracking()  { self.pauseTrackingCallCount  += 1 }
}

func XCTAssertOperationCount(_ manager:  MapManagerMock,
                             mapType:    Int = 0,
                             setMapType: Int = 0,
                             file:       StaticString = #file,
                             line:       UInt         = #line) {
  XCTAssertEqual(manager.mapTypeCallCount,    mapType,    file: file, line: line)
  XCTAssertEqual(manager.setMapTypeCallCount, setMapType, file: file, line: line)
}

func XCTAssertOperationCount(_ manager:        MapManagerMock,
                             vehicleLocations: Int = 0,
                             file:             StaticString = #file,
                             line:             UInt         = #line) {
  XCTAssertEqual(manager.vehicleLocationsCallCount, vehicleLocations, file: file, line: line)
}

func XCTAssertOperationCount(_ manager:      MapManagerMock,
                             startTracking:  Int = 0,
                             resumeTracking: Int = 0,
                             pauseTracking:  Int = 0,
                             file:           StaticString = #file,
                             line:           UInt         = #line) {
  XCTAssertEqual(manager.startTrackingCallCount,  startTracking,  file: file, line: line)
  XCTAssertEqual(manager.resumeTrackingCallCount, resumeTracking, file: file, line: line)
  XCTAssertEqual(manager.pauseTrackingCallCount,  pauseTracking,  file: file, line: line)
}
