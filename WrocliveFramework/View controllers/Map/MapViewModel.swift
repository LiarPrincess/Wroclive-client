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

public final class MapViewModel: StoreSubscriber {

  private let store: Store<AppState>
  private let environment: Environment

  /// State that is currently being presented.
  private var currentState: AppState?
  private weak var view: MapViewType?

  public init(store: Store<AppState>, environment: Environment) {
    self.store = store
    self.environment = environment
  }

  public func setView(view: MapViewType) {
    assert(self.view == nil, "View was already assigned")
    self.view = view

    // We have to start map in the center, it may be later overriden with
    // user location (when we finally retrieve it).
    self.centerMapOnDefaultLocation(animated: false)

    self.store.subscribe(self)
  }

  // MARK: - Input

  public func didChangeTrackingMode(to trackingMode: MKUserTrackingMode) {
    guard let authorization = self.currentState?.userLocationAuthorization else {
      return
    }

    switch authorization {
    case .authorized:
      break
    case .notDetermined:
      let action = UserLocationAuthorizationAction.requestWhenInUseAuthorization
      self.store.dispatch(action)
    case .denied:
      self.view?.showDeniedLocationAuthorizationAlert()
    case .restricted:
      self.view?.showGloballyDeniedLocationAuthorizationAlert()
    }
  }

  // MARK: - Store subscriber

  public func newState(state: AppState) {
    defer { self.currentState = state }

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
  // 1. Start with default center (set in 'self.setView(view:)')
  // 2. On first recieved state:
  //   - if we are 'authorized' -> center on user location
  //   - otherwise -> center on default location - already done in 1
  // 3. On any other state change:
  //   - user just authorized app -> center on user location
  private func centerMapIfNeeded(newState: AppState) {
    let new = newState.userLocationAuthorization

    guard let previousState = self.currentState else {
      if new.isAuthorized {
        self.centerMapOnUserLocation(animated: false)
      }

      return
    }

    let old = previousState.userLocationAuthorization

    if old.isNotDetermined && new.isAuthorized {
      self.centerMapOnUserLocation(animated: true)
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
    let new = newState.getVehicleLocationsResponse
    let old = self.currentState?.getVehicleLocationsResponse

    switch new {
    case .none,
         .inProgress:
      break // Leave map exactly as it is.

    case .data(let vehicles):
      let oldVehicles = old?.getData()
      if vehicles != oldVehicles {
        self.view?.showVehicles(vehicles: vehicles)
      }

    case .error(let newError):
      // If previously we did not have an error -> just show new error
      guard let oldError = old?.getError() else {
        self.view?.showApiErrorAlert(error: newError)
        return
      }

      // Otherwise we have to check if error changed
      if !self.isEqual(lhs: oldError, rhs: newError) {
        self.view?.showApiErrorAlert(error: newError)
      }
    }
  }

  private func isEqual(lhs: ApiError, rhs: ApiError) -> Bool {
    switch (lhs, rhs) {
    case (.invalidResponse, .invalidResponse),
         (.reachabilityError, .reachabilityError),
         (.otherError, .otherError):
      return true
    default:
      return false
    }
  }
}
