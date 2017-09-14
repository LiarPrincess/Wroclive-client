//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
import PromiseKit

private typealias Constants = TrackingManagerConstants

extension Notification.Name {
  static let trackingManagerDidUpdateLocations = Notification.Name("pl.kekapp.kek.trackingManagerDidUpdateLocations")
}

class TrackingManagerImpl {

  private(set) var result: TrackingResult = .success(locations: [])

  fileprivate var trackedLines: [Line] = []
  private var trackingTimer:    Timer?

  private func notifyDidUpdateLocations() {
    NotificationCenter.default.post(name: .trackingManagerDidUpdateLocations, object: nil)
  }

  fileprivate func startTimer() {
    self.stopTimer()

    guard self.trackedLines.count > 0 else {
      self.result = .success(locations: [])
      self.notifyDidUpdateLocations()
      return
    }

    let interval = Constants.locationUpdateInterval
    self.trackingTimer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
    self.trackingTimer!.tolerance = interval * 0.1

    // manually perform first tick
    self.trackingTimer!.fire()
  }

  @objc func timerFired(timer: Timer) {
    guard timer.isValid else { return }

    firstly { return Managers.network.getVehicleLocations(for: self.trackedLines) }
    .then  { self.result = .success(locations: $0) }
    .catch { self.result = .error(error: $0) }
    .always { self.notifyDidUpdateLocations() }
  }

  fileprivate func stopTimer() {
    self.trackingTimer?.invalidate()
  }
}

extension TrackingManagerImpl: TrackingManager {
  func start(_ lines: [Line]) {
    self.trackedLines = lines
    self.startTimer()
  }

  func pause() {
    self.stopTimer()
  }

  func resume() {
    self.startTimer()
  }
}
