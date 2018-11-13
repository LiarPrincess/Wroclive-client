// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import os.log
import ReSwift
import RxSwift

class UpdateScheduler: StoreSubscriber {

  private let log: OSLog
  private let store: Store<AppState>
  private let scheduler: SchedulersManagerType

  private var timer:           Observable<Void>?
  private var timerDisposable: Disposable?

  private var trackedLines: [Line] = []

  init(_ store: Store<AppState>, _ bundle: BundleManagerType, _ scheduler: SchedulersManagerType) {
    self.store = store
    self.scheduler = scheduler
    self.log = OSLog(subsystem: bundle.identifier, category: "scheduler")

    store.subscribe(self)
  }

  func start() {
    os_log("Start", log: self.log, type: .info)
    self.clearTimer()

    // if we don't have any lines then just send single update to reset map
    guard self.trackedLines.any else {
      os_log("Tick (empty)!", log: self.log, type: .info)
      self.store.dispatch(ApiAction.updateVehicleLocations)
      return
    }

    let initialTick = Observable<Void>.just(())
    let intervalTimer: Observable<Void> = {
      let interval = AppEnvironment.variables.timings.vehicleUpdateInterval
      return Observable<Int>.interval(interval, scheduler: self.scheduler.main).map { _ in () }
    }()

    self.timer = initialTick.concat(intervalTimer)
    self.timerDisposable = self.timer!
      .bind(onNext: { _ in
        os_log("Tick!", log: self.log, type: .info)
        self.store.dispatch(ApiAction.updateVehicleLocations)
      })
  }

  func pause() {
    os_log("Stop", log: self.log, type: .info)
    self.clearTimer()
  }

  private func clearTimer() {
    self.timerDisposable?.dispose()
    self.timerDisposable = nil
    self.timer = nil
  }

  func newState(state: AppState) {
    let newTrackedLines = state.userData.trackedLines
    if newTrackedLines != self.trackedLines {
      os_log("Changing tracked lines", log: self.log, type: .info)
      self.trackedLines = newTrackedLines
      self.start()
    }
  }
}
