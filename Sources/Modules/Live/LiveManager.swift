//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
import PromiseKit
import RxSwift

class LiveManager: LiveManagerType {

  private var trackedLines       = [Line]()
  private let trackingOperations = PublishSubject<TrackingOperation>()

  private enum TrackingOperation {
    case start
    case stop
  }

  lazy var vehicleLocations: ApiResponse<[Vehicle]> = trackingOperations.asObservable()
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

  func resumeTracking() {
    self.trackingOperations.onNext(.start)
  }

  func pauseTracking() {
    self.trackingOperations.onNext(.stop)
  }
}

// MARK: - Helpers

private func createTrackingObservable(lines: [Line]) -> ApiResponse<[Vehicle]> {
  // if we don't have any lines then just send single empty to reset map
  guard lines.any else {
    return Observable.just(.success([]))
  }

  let interval = AppInfo.Timings.locationUpdateInterval

  let initialTick   = Observable<Void>.just(())
  let trackingTimer = Observable<Int>.interval(interval, scheduler: MainScheduler.instance).map { _ in () }

  return initialTick
    .concat(trackingTimer)
    .flatMap { _ in Managers.api.vehicleLocations(for: lines) }
}
