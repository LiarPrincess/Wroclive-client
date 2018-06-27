// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import MapKit
import Foundation
import RxSwift
import RxTest
@testable import Wroclive

class UserLocationManagerMock: RxMock, UserLocationManagerType {

  let scheduler: TestScheduler

  private var currentLocationCallCount = 0
  private var authorizationCallCount = 0
  private var requestWhenInUseAuthorizationCallCount = 0

  init(_ scheduler: TestScheduler) {
    self.scheduler = scheduler
  }

  // MARK: - Current location

  private var _userLocations = [TestTime:Single<CLLocationCoordinate2D>]()

  var currentLocation: Single<CLLocationCoordinate2D> {
    self.currentLocationCallCount += 1
    return self.current(from: self._userLocations)
  }

  func mockUserLocation(at time: TestTime, _ value: Single<CLLocationCoordinate2D>) {
    self.schedule(at: time, value, in: &self._userLocations)
  }

  // MARK: - Authorization

  private var _authorizations = PublishSubject<CLAuthorizationStatus>()

  var authorization: Observable<CLAuthorizationStatus> {
    self.authorizationCallCount += 1
    return self._authorizations.asObservable()
  }

  func mockAuthorization(at time: TestTime, _ value: CLAuthorizationStatus) {
    self.mockNext(self._authorizations, at: time, element: value)
  }

  // MARK: - Request authorization

  func requestWhenInUseAuthorization() {
    self.requestWhenInUseAuthorizationCallCount += 1
  }

  // MARK: - Asserts

  func assertOperationCount(currentLocation:               Int,
                            authorization:                 Int,
                            requestWhenInUseAuthorization: Int,
                            file:                          StaticString = #file,
                            line:                          UInt         = #line) {
    XCTAssertEqual(self.currentLocationCallCount, currentLocation, file: file, line: line)
    XCTAssertEqual(self.authorizationCallCount, authorization, file: file, line: line)
    XCTAssertEqual(self.requestWhenInUseAuthorizationCallCount, requestWhenInUseAuthorization, file: file, line: line)
  }
}
