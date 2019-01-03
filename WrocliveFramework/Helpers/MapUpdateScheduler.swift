// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import os.log
import ReSwift
import RxSwift

public final class MapUpdateScheduler: StoreSubscriber {

  private let store: Store<AppState>
  private var trackedLines: [Line] = []

  private var timer:           Observable<Void>?
  private var timerDisposable: Disposable?

  private var log: OSLog { return AppEnvironment.log.mapUpdate }

  public init(_ store: Store<AppState>) {
    self.store = store
    store.subscribe(self)
  }

  public func start() {
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
      let interval = AppEnvironment.configuration.time.vehicleUpdateInterval
      return Observable<Int>.interval(interval, scheduler: AppEnvironment.schedulers.main).map { _ in () }
    }()

    self.timer = initialTick.concat(intervalTimer)
    self.timerDisposable = self.timer!
      .bind(onNext: { _ in
        os_log("Tick!", log: self.log, type: .info)
        self.store.dispatch(ApiAction.updateVehicleLocations)
      })
  }

  public func stop() {
    os_log("Stop", log: self.log, type: .info)
    self.clearTimer()
  }

  private func clearTimer() {
    self.timerDisposable?.dispose()
    self.timerDisposable = nil
    self.timer = nil
  }

  public func newState(state: AppState) {
    let newTrackedLines = state.userData.trackedLines
    if newTrackedLines != self.trackedLines {
      os_log("Changing tracked lines", log: self.log, type: .info)
      self.trackedLines = newTrackedLines
      self.start()
    }
  }
}
