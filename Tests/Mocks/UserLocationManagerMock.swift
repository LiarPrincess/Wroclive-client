// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import MapKit
import Foundation
import RxSwift
import RxTest
@testable import Wroclive

typealias UserLocationEvent      = RecordedEvent<CLLocationCoordinate2D>
typealias UserLocationErrorEvent = RecordedEvent<UserLocationError>
typealias AuthorizationEvent     = RecordedEvent<CLAuthorizationStatus>

class UserLocationManagerMock: RxMock, UserLocationManagerType {

  let scheduler: TestScheduler
  private var _current       = PublishSubject<CLLocationCoordinate2D>()
  private var _authorization = PublishSubject<CLAuthorizationStatus>()

  init(_ scheduler: TestScheduler) {
    self.scheduler = scheduler
  }

  // MARK: - UserLocationManagerType

  private var currentCallCount       = 0
  private var authorizationCallCount = 0
  private var requestWhenInUseAuthorizationCallCount = 0

  var current: Observable<CLLocationCoordinate2D> {
    self.currentCallCount += 1
    return self._current.asObservable()
  }

  var authorization: Observable<CLAuthorizationStatus> {
    self.authorizationCallCount += 1
    return self._authorization.asObservable()
  }

  func requestWhenInUseAuthorization() {
    self.requestWhenInUseAuthorizationCallCount += 1
  }

  // MARK: - Helpers

  func mockUserLocationEvents(_ events: [UserLocationEvent]) {
    self.mockEvents(self._current, events)
  }

  func mockUserLocationError(_ event: UserLocationErrorEvent) {
    self.mockError(self._current, event)
  }

  func mockAuthorizationEvents(_ events: [AuthorizationEvent]) {
    self.mockEvents(self._authorization, events)
  }

  func assertOperationCount(current:                       Int,
                            authorization:                 Int,
                            requestWhenInUseAuthorization: Int,
                            file:                          StaticString = #file,
                            line:                          UInt         = #line) {
    XCTAssertEqual(self.currentCallCount,       current,       file: file, line: line)
    XCTAssertEqual(self.authorizationCallCount, authorization, file: file, line: line)
    XCTAssertEqual(self.requestWhenInUseAuthorizationCallCount, requestWhenInUseAuthorization, file: file, line: line)
  }
}
