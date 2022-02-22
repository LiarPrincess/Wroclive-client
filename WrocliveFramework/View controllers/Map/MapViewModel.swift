// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import MapKit
import ReSwift
import PromiseKit

private typealias Defaults = MapViewController.Constants.Default

public protocol MapViewType: AnyObject {
  func setMapType(mapType: MapType)
  func setCenter(location: CLLocationCoordinate2D, animated: Bool)
  func showVehicles(vehicles: [Vehicle])

  func showDeniedLocationAuthorizationAlert()
  func showGloballyDeniedLocationAuthorizationAlert()
  func showApiErrorAlert(error: ApiError)
}

public protocol MapViewModelDelegate: AnyObject {
  func openSettingsApp()
}

public final class MapViewModel: StoreSubscriber {

  private let store: Store<AppState>
  private let environment: Environment
  private weak var delegate: MapViewModelDelegate?

  /// State that is currently being presented.
  private let getVehicleLocationsState = StoreApiResponseTracker<[Vehicle]>()
  private let userLocationAuthorizationState = StoreStateTracker<UserLocationAuthorization>()
  private weak var view: MapViewType?

  public init(store: Store<AppState>,
              environment: Environment,
              delegate: MapViewModelDelegate?) {
    self.store = store
    self.environment = environment
    self.delegate = delegate
  }

  public func setView(view: MapViewType) {
    assert(self.view == nil, "View was already assigned")
    self.view = view
  }

  // MARK: - View input

  public func viewDidLoad() {
    // We have to start map in the center, it may be later overriden with
    // user location (when we finally retrieve it).
    self.centerMapOnDefaultLocation(animated: false)
    // Will automatically call 'newState(state:)'.
    self.store.subscribe(self)
  }

  public func viewDidChangeTrackingMode(to trackingMode: MKUserTrackingMode) {
    guard let authorization = self.userLocationAuthorizationState.currentValue else {
      return
    }

    switch authorization {
    case .authorized,
         .unknownValue:
      break
    case .notDetermined:
      self.environment.userLocation.requestWhenInUseAuthorization()
    case .denied:
      self.view?.showDeniedLocationAuthorizationAlert()
    case .restricted:
      self.view?.showGloballyDeniedLocationAuthorizationAlert()
    }
  }

  public func viewDidRequestOpenSettingsApp() {
    self.delegate?.openSettingsApp()
  }

  // MARK: - Store subscriber

  public func newState(state: AppState) {
    self.updateMapType(newState: state)
    self.centerMapIfNeeded(newState: state)
    self.updateVehicleLocationsIfNeeded(newState: state)
  }

  // MARK: - Map type

  private func updateMapType(newState: AppState) {
    let mapType = newState.mapType
    self.view?.setMapType(mapType: mapType)
  }

  // MARK: - Map center

  // Center map:
  // 1. Start with default center (set in 'self.viewDidLoad()')
  // 2. On first recieved state:
  //   - if we are 'authorized' -> center on user location
  //   - otherwise -> center on default location - already done in 1
  // 3. On any other state change:
  //   - user just authorized app -> center on user location
  private func centerMapIfNeeded(newState: AppState) {
    let state = newState.userLocationAuthorization
    let result = self.userLocationAuthorizationState.update(from: state)

    switch result {
    case let .initial(value):
      // 1st update
      switch value {
      case .authorized,
           .unknownValue:
        self.centerMapOnUserLocation(animated: false)

      case .notDetermined,
           .restricted,
           .denied:
        break
      }

    case let .changed(new: new, old: old):
      let wasNotDetermined = self.isNotDeterminedOrUnknown(authorization: old)
      let isAuthorized = self.isAuthorizedOrUnknownValue(authorization: new)

      if wasNotDetermined && isAuthorized {
        self.centerMapOnUserLocation(animated: true)
      }

    case .sameAsBefore:
      break
    }
  }

  private func isNotDeterminedOrUnknown(authorization: UserLocationAuthorization) -> Bool {
    switch authorization {
    case .notDetermined,
         .unknownValue:
      return true
    case .authorized,
         .restricted,
         .denied:
      return false
    }
  }

  private func isAuthorizedOrUnknownValue(authorization: UserLocationAuthorization) -> Bool {
    switch authorization {
    case .authorized,
         .unknownValue:
      return true
    case .notDetermined,
         .restricted,
         .denied:
      return false
    }
  }

  private func centerMapOnUserLocation(animated: Bool) {
    // Ignore errors
    _ = self.environment.userLocation.getCurrent().done { [weak self] location in
      self?.view?.setCenter(location: location, animated: animated)
    }
  }

  private func centerMapOnDefaultLocation(animated: Bool) {
    self.view?.setCenter(location: Defaults.center, animated: animated)
  }

  // MARK: - Vehicle locations

  // On vehicle response:
  // - if data -> update map
  // - if error -> show alert
  private func updateVehicleLocationsIfNeeded(newState: AppState) {
    let response = newState.getVehicleLocationsResponse
    let result = self.getVehicleLocationsState.update(from: response)

    switch result {
    case .final:
      // Should not happen, we never call 'self.getVehicleLocationsState.markAsFinal'.
      break

    case .initialData(let vehicles),
         .newData(let vehicles):
      self.view?.showVehicles(vehicles: vehicles)

    case .sameDataAsBefore:
      // Nothing to do, it will not update the map anyway.
      break

    case .initialError(let error),
         .newError(let error):
      self.view?.showApiErrorAlert(error: error)

    case .sameErrorAsBefore:
      // Nothing to do, we have already shown this error.
      break

    case .initialInProgres,
         .inProgres,
         .initialNone,
         .none:
      // Leave map exactly as it is.
      break
    }
  }
}
