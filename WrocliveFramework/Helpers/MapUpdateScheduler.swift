// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import os.log
import ReSwift
import PromiseKit

public final class MapUpdateScheduler: StoreSubscriber {

  private let store: Store<AppState>
  private let environment: Environment

  private var timer: Timer?
  private var trackedLines: [Line] = []

  private var log: OSLog {
    return self.environment.log.mapUpdate
  }

  public init(store: Store<AppState>, environment: Environment) {
    self.store = store
    self.environment = environment
    store.subscribe(self)
  }

  public func start() {
    os_log("Start", log: self.log, type: .info)
    self.clearTimer()

    // If we don't have any lines then just send single update to reset map
    guard self.trackedLines.any else {
      os_log("Tick (empty)!", log: self.log, type: .debug)
      os_log("Stoping updates as there are no lines to track", log: self.log, type: .debug)
      self.store.dispatch(ApiAction.setVehicleLocations(.data([])))
      return
    }

    let interval = self.environment.configuration.timing.vehicleLocationUpdateInterval
    self.timer = Timer.scheduledTimer(timeInterval: interval,
                                      target: self,
                                      selector: #selector(self.timerFired),
                                      userInfo: nil,
                                      repeats: true)
    self.timer?.tolerance = interval * 0.1

    // Manually perform first tick
    self.timer?.fire()
  }

  @objc
  internal func timerFired(timer: Timer) {
    guard timer.isValid else { return }

    os_log("Tick!", log: self.log, type: .debug)
    self.store.dispatch(ApiMiddlewareActions.requestVehicleLocations)
  }

  public func stop() {
    os_log("Stop", log: self.log, type: .info)
    self.clearTimer()
  }

  private func clearTimer() {
    self.timer?.invalidate()
    self.timer = nil
  }

  public func newState(state: AppState) {
    let newTrackedLines = state.trackedLines
    if newTrackedLines != self.trackedLines {
      os_log("Setting new tracked lines", log: self.log, type: .debug)
      self.trackedLines = newTrackedLines
      self.start()
    }
  }
}
