// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import MapKit
import ReSwift
import RxSwift
import RxCocoa

private typealias Defaults = MapViewControllerConstants.Defaults

protocol MapViewModelEnvironment {
  var schedulers: SchedulersManagerType { get }
  var userLocation: UserLocationManagerType { get }
  var variables: EnvironmentVariables { get }
}

extension Environment: MapViewModelEnvironment { }

class MapViewModel {

  private let disposeBag = DisposeBag()

  // MARK: - Input

  let didChangeTrackingMode: AnyObserver<MKUserTrackingMode>
  let viewDidAppear:         AnyObserver<Void>

  // MARK: - Output

  let mapCenter:        Driver<CLLocationCoordinate2D>
  let vehicleLocations: Driver<[Vehicle]>

  let showAlert: Driver<MapViewAlert>

  // swiftlint:disable:next function_body_length
  init(_ store: Store<AppState>, _ environment: MapViewModelEnvironment) {
    let _didChangeTrackingMode = PublishSubject<MKUserTrackingMode>()
    self.didChangeTrackingMode = _didChangeTrackingMode.asObserver()

    let _viewDidAppear = PublishSubject<Void>()
    self.viewDidAppear = _viewDidAppear.asObserver()

    // map center
    let authorization = environment.userLocation.authorization.share()

    self.mapCenter = {
      let initialAuthorization = _viewDidAppear.withLatestFrom(authorization)

      let authorizationChangedFromNonDetermined = Observable
        .zip(authorization, authorization.skip(1)) { (previous: $0, current: $1) }
        .filter { $0.previous == .notDetermined }
        .map { $0.current }

      return Observable.merge(initialAuthorization, authorizationChangedFromNonDetermined)
        .filter { $0 == .authorizedAlways || $0 == .authorizedWhenInUse }
        .flatMapLatest { _ in environment.userLocation.getCurrent().catchError { _ in .never() } }
        .startWith(Defaults.location)
        .asDriver(onErrorDriveWith: .never())
    }()

    // vehicles
    let vehicleResponse = store.rx.state
      .map { $0.apiData.vehicleLocations }
      .asDriver(onErrorDriveWith: .never())

    self.vehicleLocations = vehicleResponse.data()

    // alerts
    self.showAlert = {
      let deniedAuthorizationAlert = _didChangeTrackingMode
        .withLatestFrom(authorization)
        .flatMapLatest(toDeniedAuthorizationAlert)

      let apiErrorAlert = vehicleResponse
        .errors()
        .map { MapViewAlert.apiError($0 as? ApiError ?? .generalError) }
        .asObservable()

      return Observable.merge(deniedAuthorizationAlert, apiErrorAlert)
        .asDriver(onErrorDriveWith: .never())
    }()

    // bindings
    let requestAuthorization: Observable<Void> = {
      let delay          = environment.variables.time.locationAuthorizationPromptDelay
      let delayScheduler = environment.schedulers.main

      let delayedViewDidAppear = _viewDidAppear.delay(delay, scheduler: delayScheduler)
      let trackingModeChanged  = _didChangeTrackingMode.map { _ in () }

      return Observable.merge(delayedViewDidAppear, trackingModeChanged)
        .withLatestFrom(authorization)
        .filter { $0 == .notDetermined }
        .map { _ in () }
    }()

    requestAuthorization
      .bind(onNext: { _ in environment.userLocation.requestWhenInUseAuthorization() })
      .disposed(by: self.disposeBag)
  }
}

// MARK: - Helpers

private func toDeniedAuthorizationAlert(_ authorization: CLAuthorizationStatus) -> Observable<MapViewAlert> {
  switch authorization {
  case .denied: return .just(.deniedLocationAuthorization)
  case .restricted: return .just(.globallyDeniedLocationAuthorization)
  case .notDetermined,
       .authorizedAlways,
       .authorizedWhenInUse: return .never()
  }
}
