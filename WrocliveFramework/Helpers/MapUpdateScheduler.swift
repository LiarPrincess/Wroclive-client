// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import os.log
import Foundation
import ReSwift
import PromiseKit

public final class MapUpdateScheduler: StoreSubscriber {

  private let store: Store<AppState>
  private let environment: Environment

  private var timer: Timer?
  private var trackedLines = [Line]()
  private var isSubscribedToStore = false

  private var log: OSLog {
    return self.environment.log.mapUpdate
  }

  public init(store: Store<AppState>, environment: Environment) {
    self.store = store
    self.environment = environment
  }

  public func start() {
    os_log("Start", log: self.log, type: .info)

    // Calling 'store.subscribe(self)' will call 'newState(state:)' which:
    // 1. fills 'self.trackedLines'
    // 2. calls 'self.start()' again
    //
    // If we subscribed in 'init' then that would call 'self.start' and dispatch
    // request, we don't want that.
    guard self.isSubscribedToStore else {
      self.isSubscribedToStore = true
      self.store.subscribe(self)
      return
    }

    // Stop updates for the lines that we are currently tracking.
    // If we have request in-flight then we have minor race condition,
    // but that's ok, we will not try to handle this special case.
    self.clearTimer()

    // If are not tracking any lines -> send single update to reset map.
    guard self.trackedLines.any else {
      os_log("Tick (empty)!", log: self.log, type: .debug)
      os_log("Stoping updates as there are no lines to track", log: self.log, type: .debug)
      self.store.dispatch(ApiAction.setVehicleLocations(.data([])))
      return
    }

    // We are tracking some lines -> start timer.
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
