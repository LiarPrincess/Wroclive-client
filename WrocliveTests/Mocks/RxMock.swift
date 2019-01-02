//// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
//// If a copy of the MPL was not distributed with this file,
//// You can obtain one at http://mozilla.org/MPL/2.0/.
//
//import XCTest
//import RxSwift
//import RxTest
//import Foundation
//
//protocol RxMock {
//  var scheduler: TestScheduler { get }
//}
//
//extension RxMock {
//
//  func mockNext<Element>(_ source: PublishSubject<Element>, at time: TestTime, element: Element) {
//    self.scheduler.scheduleAt(time) { source.onNext(element) }
//  }
//
//  func current<Source>(from events: [TestTime:Source]) -> Source {
//    let time = self.scheduler.clock
//
//    guard let event = events[time] else {
//      fatalError("No event scheduled at \(time)!")
//    }
//
//    return event
//  }
//
//  func schedule<E>(at time: TestTime, _ value: E, in events: inout [TestTime:E]) {
//    if events[time] != nil {
//      fatalError("Another event is already scheduled at \(time)!")
//    }
//    events[time] = value
//  }
//}
