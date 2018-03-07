//
//  Created by Michal Matuszczyk
//  Copyright © 2018 Michal Matuszczyk. All rights reserved.
//

import XCTest
import MapKit
import Foundation
import RxSwift
import RxTest
@testable import Wroclive

// swiftlint:disable identifier_name
// swiftlint:disable implicitly_unwrapped_optional

class UserLocationManagerMock: UserLocationManagerType {

  fileprivate var currentCallCount       = 0
  fileprivate var authorizationCallCount = 0
  fileprivate var requestWhenInUseAuthorizationCallCount = 0

  var _current:       TestableObservable<CLLocationCoordinate2D>!
  var _authorization: TestableObservable<CLAuthorizationStatus>!

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
}

func XCTAssertOperationCount(_ manager:                     UserLocationManagerMock,
                             current:                       Int = 0,
                             authorization:                 Int = 0,
                             requestWhenInUseAuthorization: Int = 0,
                             file:                          StaticString = #file,
                             line:                          UInt         = #line) {
  XCTAssertEqual(manager.currentCallCount,       current,       file: file, line: line)
  XCTAssertEqual(manager.authorizationCallCount, authorization, file: file, line: line)
  XCTAssertEqual(manager.requestWhenInUseAuthorizationCallCount, requestWhenInUseAuthorization, file: file, line: line)
}
