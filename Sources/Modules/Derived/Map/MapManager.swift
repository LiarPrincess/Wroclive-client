//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
import PromiseKit
import RxSwift

class MapManager: MapManagerType {

  // MARK: - Map type

  private lazy var _mapType: BehaviorSubject<MapType> = {
    let preferredMapType = Managers.userDefaults.getString(.preferredMapType).flatMap(decode)
    return BehaviorSubject(value: preferredMapType ?? .standard)
  }()

  lazy var mapType: Observable<MapType> = self._mapType.asObservable().share(replay: 1)

  func setMapType(_ mapType: MapType) {
    Managers.userDefaults.setString(.preferredMapType, to: encode(mapType))
    self._mapType.onNext(mapType)
  }

  // MARK: - Tracking

  private(set) var result: TrackingResult = .success(locations: []) {
    didSet { Managers.notification.post(.vehicleLocationsDidUpdate) }
  }

  fileprivate var trackedLines: [Line] = []
  private var trackingTimer:    Timer?

  fileprivate func startTimer() {
    self.stopTimer()

    guard self.trackedLines.any else {
      self.result = .success(locations: [])
      return
    }

    let interval = AppInfo.Timings.locationUpdateInterval
    self.trackingTimer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
    self.trackingTimer?.tolerance = interval * 0.1

    // manually perform first tick
    self.trackingTimer?.fire()
  }

  @objc
  func timerFired(timer: Timer) {
    guard timer.isValid else { return }

    firstly { Managers.api.getVehicleLocations(for: self.trackedLines) }
    .then  { self.result = .success(locations: $0) }
    .catch { self.result = .error(error: $0) }
  }

  fileprivate func stopTimer() {
    self.trackingTimer?.invalidate()
    self.trackingTimer = nil
  }
}

extension MapManager {
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

// MARK: - Map type encoding

private enum MapTypeEncodings {
  static let standard  = "standard"
  static let satellite = "satelite"
  static let hybrid    = "hybrid"
}

private func encode(_ mapType: MapType) -> String {
  switch mapType {
  case .standard:  return MapTypeEncodings.standard
  case .satellite: return MapTypeEncodings.satellite
  case .hybrid:    return MapTypeEncodings.hybrid
  }
}

private func decode(_ value: String) -> MapType? {
  switch value.lowercased() {
  case MapTypeEncodings.standard:  return MapType.standard
  case MapTypeEncodings.satellite: return MapType.satellite
  case MapTypeEncodings.hybrid:    return MapType.hybrid
  default: return nil
  }
}
