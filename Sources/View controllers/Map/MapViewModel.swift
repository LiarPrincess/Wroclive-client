// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import MapKit
import RxSwift
import RxCocoa

private typealias Defaults = MapViewControllerConstants.Defaults

class MapViewModel {

  // MARK: - Input

  let didChangeTrackingMode: AnyObserver<MKUserTrackingMode>
  let viewDidAppear:         AnyObserver<Void>

  // MARK: - Output

  let mapCenter: Driver<CLLocationCoordinate2D>
  let vehicles:  Driver<[Vehicle]>
  let showAlert: Driver<MapViewAlert>

  // swiftlint:disable:next function_body_length
  init() {
    let _didChangeTrackingMode = PublishSubject<MKUserTrackingMode>()
    self.didChangeTrackingMode = _didChangeTrackingMode.asObserver()

    let _viewDidAppear = PublishSubject<Void>()
    self.viewDidAppear = _viewDidAppear.asObserver()

    let authorizations   = AppEnvironment.userLocation.authorization.share()
    let vehicleResponses = AppEnvironment.live.vehicles.share()

    self.mapCenter = {
      let initialAuthorization = _viewDidAppear.withLatestFrom(authorizations)

      let authorizationChangedFromNonDetermined = Observable
        .zip(authorizations, authorizations.skip(1)) { (previous: $0, current: $1) }
        .filter { $0.previous == .notDetermined }
        .map { $0.current }

      return Observable.merge(initialAuthorization, authorizationChangedFromNonDetermined)
        .filter { $0 == .authorizedAlways || $0 == .authorizedWhenInUse }
        .flatMapLatest { _ in AppEnvironment.userLocation.current.take(1) }
        .startWith(Defaults.location)
        .asDriver(onErrorDriveWith: .never())
    }()

    self.vehicles = vehicleResponses.values()
      .asDriver(onErrorDriveWith: .never())

    self.showAlert = {
      let requestAuthorizationAlert: Observable<MapViewAlert> = {
        let delay          = AppEnvironment.variables.timings.locationAuthorizationPromptDelay
        let delayScheduler = AppEnvironment.schedulers.main

        let delayedViewDidAppear = _viewDidAppear.delay(delay, scheduler: delayScheduler)
        let trackingModeChanged  = _didChangeTrackingMode.map { _ in () }

        return Observable.merge(delayedViewDidAppear, trackingModeChanged)
          .withLatestFrom(authorizations)
          .flatMapLatest(toRequestAuthorizationAlert)
      }()

      let deniedAuthorizationAlert = _didChangeTrackingMode
        .withLatestFrom(authorizations)
        .flatMapLatest(toDeniedAuthorizationAlert)

      let apiErrorAlert = vehicleResponses.errors()
        .map { MapViewAlert.apiError(error: $0) }

      return Observable.merge(requestAuthorizationAlert, deniedAuthorizationAlert, apiErrorAlert)
        .asDriver(onErrorDriveWith: .never())
    }()
  }
}

// MARK: - Helpers

private func toRequestAuthorizationAlert(_ authorization: CLAuthorizationStatus) -> Observable<MapViewAlert> {
  switch authorization {
  case .notDetermined: return .just(.requestLocationAuthorization)
  case .denied,
       .restricted,
       .authorizedAlways,
       .authorizedWhenInUse: return .never()
  }
}

private func toDeniedAuthorizationAlert(_ authorization: CLAuthorizationStatus) -> Observable<MapViewAlert> {
  switch authorization {
  case .denied:     return .just(.deniedLocationAuthorization)
  case .restricted: return .just(.globallyDeniedLocationAuthorization)
  case .notDetermined,
       .authorizedAlways,
       .authorizedWhenInUse: return .never()
  }
}
