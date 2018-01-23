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

// MARK: - Tracking

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
    .flatMap { _ in ApiManagerAdapter.getVehicleLocations(for: lines) }
}
