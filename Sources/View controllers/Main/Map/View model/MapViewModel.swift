// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import MapKit
import RxSwift
import RxCocoa

private typealias Defaults = MapViewControllerConstants.Defaults

protocol MapViewModelType {
  var inputs:  MapViewModelInputs  { get }
  var outputs: MapViewModelOutputs { get }
}

class MapViewModel: MapViewModelType, MapViewModelInputs, MapViewModelOutputs {

  // MARK: - Properties

  private let _trackingModeChanged = PublishSubject<MKUserTrackingMode>()
  private let _viewDidAppear       = PublishSubject<Void>()

  // hot observables:
  private lazy var _locationAuthorization: Observable<CLAuthorizationStatus> = AppEnvironment.userLocation.authorization.share()
  private lazy var _vehicleLocations:      ApiResponse<[Vehicle]>            = AppEnvironment.live.mpkVehicles

  // MARK: - Input

  lazy var trackingModeChanged: AnyObserver<MKUserTrackingMode> = self._trackingModeChanged.asObserver()
  lazy var viewDidAppear:       AnyObserver<Void>               = self._viewDidAppear.asObserver()

  // MARK: - Output

  lazy var mapCenter: Driver<CLLocationCoordinate2D> = {
    let viewDidAppearWithAuthorization = self._viewDidAppear
      .flatMapFirst { [unowned self] _ in self._locationAuthorization.take(1) }

    let authorizationChangedFromNonDetermined: Observable<CLAuthorizationStatus> = {
      let previous = self._locationAuthorization
      let current  = self._locationAuthorization.skip(1)
      return Observable.zip(previous, current) { (previous: $0, current: $1) }
        .filter { $0.previous == .notDetermined }
        .map { $0.current }
    }()

    return Observable.merge(viewDidAppearWithAuthorization, authorizationChangedFromNonDetermined)
      .flatMapLatest(toSingleUserLocationIfAuthorized)
      .startWith(Defaults.location)
      .asDriver(onErrorDriveWith: .never())
  }()

  lazy var vehicleLocations: Driver<[Vehicle]> = self._vehicleLocations
    .values()
    .asDriver(onErrorJustReturn: [])

  lazy var showLocationAuthorizationAlert: Driver<Void> = {
    let delay          = AppEnvironment.variables.timings.locationAuthorizationPromptDelay
    let delayScheduler = AppEnvironment.schedulers.main

    let delayedViewDidAppear = self._viewDidAppear.delay(delay, scheduler: delayScheduler)
    let trackingModeChanged  = self._trackingModeChanged.map { _ in () }

    return Observable.merge(delayedViewDidAppear, trackingModeChanged)
      .flatMapLatest { [unowned self] _ in self._locationAuthorization.take(1) }
      .filter { $0 == .notDetermined }
      .map { _ in () }
      .asDriver(onErrorDriveWith: .never())
  }()

  lazy var showDeniedLocationAuthorizationAlert: Driver<DeniedLocationAuthorizationAlert> = self._trackingModeChanged
    .withLatestFrom(self._locationAuthorization)
    .flatMapLatest(toDeniedAuthorizationAlert)
    .asDriver(onErrorDriveWith: .never())

  lazy var showApiErrorAlert: Driver<ApiError> = self._vehicleLocations
    .errors()
    .asDriver(onErrorDriveWith: .never())

  // MARK: - Inputs/Outputs

  var inputs:  MapViewModelInputs  { return self }
  var outputs: MapViewModelOutputs { return self }
}

// MARK: - Helpers

private func toSingleUserLocationIfAuthorized(_ authorization: CLAuthorizationStatus) -> Observable<CLLocationCoordinate2D> {
  switch authorization {
  case .authorizedAlways,
       .authorizedWhenInUse: return AppEnvironment.userLocation.current.catchError { _ in .never() }.take(1)
  case .notDetermined,
       .denied,
       .restricted: return .never()
  }
}

private func toDeniedAuthorizationAlert(_ authorization: CLAuthorizationStatus) -> Observable<DeniedLocationAuthorizationAlert> {
  switch authorization {
  case .denied:     return .just(.deniedLocationAuthorization)
  case .restricted: return .just(.globallyDeniedLocationAuthorization)
  case .notDetermined,
       .authorizedAlways,
       .authorizedWhenInUse: return .never()
  }
}
