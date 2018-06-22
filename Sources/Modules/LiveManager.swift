// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import RxSwift

class LiveManager: LiveManagerType {

  private var trackedLines       = [Line]()
  private let trackingOperations = PublishSubject<TrackingOperation>()

  private enum TrackingOperation {
    case start
    case stop
  }

  lazy var mpkVehicles: ApiResponse<[Vehicle]> = trackingOperations.asObservable()
    .flatMapLatest { [unowned self] operation -> ApiResponse<[Vehicle]> in
      switch operation {
      case .start: return createTrackingObservable(lines: self.trackedLines)
      case .stop:  return .never()
      }
    }
    .share(replay: 1)

  func startTracking(_ lines: [Line]) {
    self.trackedLines = lines
    self.trackingOperations.onNext(.start)
  }

  func resumeUpdates() {
    self.trackingOperations.onNext(.start)
  }

  func pauseUpdates() {
    self.trackingOperations.onNext(.stop)
  }
}

// MARK: - Helpers

private func createTrackingObservable(lines: [Line]) -> ApiResponse<[Vehicle]> {
  // if we don't have any lines then just send single empty to reset map
  guard lines.any else {
    return Observable.just(.success([]))
  }

  let interval  = AppEnvironment.variables.timings.locationUpdateInterval
  let scheduler = AppEnvironment.schedulers.main

  let initialTick   = Observable<Void>.just(())
  let trackingTimer = Observable<Int>.interval(interval, scheduler: scheduler).map { _ in () }

  return initialTick
    .concat(trackingTimer)
    .flatMap { _ in AppEnvironment.api.vehicleLocations(for: lines) }
}
