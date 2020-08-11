// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import MapKit
import Foundation
import RxSwift
import RxTest
@testable import WrocliveFramework

class UserLocationManagerMock: UserLocationManagerType {

  private(set) var currentLocationCallCount = 0
  private(set) var authorizationCallCount = 0
  private(set) var requestWhenInUseAuthorizationCallCount = 0

  private let scheduler: TestScheduler

  init(_ scheduler: TestScheduler) {
    self.scheduler = scheduler
  }

  // MARK: - Current location

  private var _userLocations = [TestTime:Single<CLLocationCoordinate2D>]()

  func getCurrent() -> PrimitiveSequence<SingleTrait, CLLocationCoordinate2D> {
    self.currentLocationCallCount += 1

    let time = self.scheduler.clock
    guard let event = self._userLocations[time] else {
      fatalError("No event scheduled at \(time)!")
    }

    return event
  }

  func mockUserLocation(at time: TestTime, _ value: Single<CLLocationCoordinate2D>) {
    if self._userLocations[time] != nil {
      fatalError("Another event is already scheduled at \(time)!")
    }
    self._userLocations[time] = value
  }

  // MARK: - Authorization

  private var _authorizations = PublishSubject<CLAuthorizationStatus>()

  var authorization: Observable<CLAuthorizationStatus> {
    self.authorizationCallCount += 1
    return self._authorizations.asObservable()
  }

  func mockAuthorization(at time: TestTime, _ value: CLAuthorizationStatus) {
    self.scheduler.scheduleAt(time) { [unowned self] in self._authorizations.onNext(value) }
  }

  // MARK: - Request authorization

  func requestWhenInUseAuthorization() {
    self.requestWhenInUseAuthorizationCallCount += 1
  }
}
