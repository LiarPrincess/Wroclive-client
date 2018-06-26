// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import RxSwift
import RxTest
import Foundation

class RecordedEvent<Data> {
  let time: TestTime
  let data: Data

  init(_ time: TestTime, _ data: Data) {
    self.time = time
    self.data = data
  }
}

typealias RecordedErrorEvent = RecordedEvent<Error>

protocol RxMock {
  var scheduler: TestScheduler { get }
}

extension RxMock {

  // MARK: - Hot

  func mockEvents<D>(_ source: PublishSubject<D>, _ events: [RecordedEvent<D>]) {
    for event in events {
      self.scheduler.scheduleAt(event.time) { source.onNext(event.data) }
    }
  }

  func mockError<D, E: Error>(_ source: PublishSubject<D>, _ event: RecordedEvent<E>) {
    self.scheduler.scheduleAt(event.time) { source.onError(event.data) }
  }

  func mockNext<Element>(_ source: PublishSubject<Element>, at time: TestTime, element: Element) {
    self.scheduler.scheduleAt(time) { source.onNext(element) }
  }

  // MARK: - Cold

  func current<Source>(from events: [TestTime:Source]) -> Source {
    let time = self.scheduler.clock

    guard let event = events[time] else {
      fatalError("No event scheduled at \(time)!")
    }

    return event
  }

  func preventDoubleScheduling<E>(at time: TestTime, in events: [TestTime:E]) {
    if events[time] != nil {
      fatalError("Another event is already scheduled at \(time)!")
    }
  }
}
