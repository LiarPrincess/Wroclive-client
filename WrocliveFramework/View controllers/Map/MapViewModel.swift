// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import MapKit
import ReSwift
import PromiseKit

private typealias Defaults = MapViewControllerConstants.Defaults

public protocol MapViewType: AnyObject {
  func setCenter(location: CLLocationCoordinate2D)
  // TODO: VM should calculate updates
  func updateVehicleLocations(vehicles: [Vehicle])

  func showDeniedLocationAuthorizationAlert()
  func showGloballyDeniedLocationAuthorizationAlert()
  func showApiErrorAlert(error: ApiError)
}

public final class MapViewModel: StoreSubscriber {

  private let store: Store<AppState>
  private let environment: Environment

  private var previousState: AppState?
  private weak var view: MapViewType?

  private var userLocationAuthorization: UserLocationAuthorization {
    return self.store.state.userData.userLocationAuthorization
  }

  public init(store: Store<AppState>, environment: Environment) {
    self.store = store
    self.environment = environment
    store.subscribe(self)
  }

  public func setView(view: MapViewType) {
    self.view = view
  }

  // MARK: - Input

  public func viewDidAppear() {
    self.askForUserLocationAuthorizationIfNotDetermined(withDelay: true)
  }

  public func didChangeTrackingMode(to trackingMode: MKUserTrackingMode) {
    self.askForUserLocationAuthorizationIfNotDetermined(withDelay: false)
    self.showDeniedAuthorizationAlertIfNeeded()
  }

  private func askForUserLocationAuthorizationIfNotDetermined(withDelay: Bool) {
    let authorization = self.userLocationAuthorization
    guard authorization.isNotDetermined else {
      return
    }

    let configDelay = self.environment.configuration.timing.locationAuthorizationPromptDelay
    let delay = withDelay ? configDelay : TimeInterval.zero

    // TODO: Is this really map responsibility? Move it to store (with action)?
    PromiseKit.after(seconds: delay).done { [weak self] _ in
      self?.environment.userLocation.requestWhenInUseAuthorization()
    }
  }

  private func showDeniedAuthorizationAlertIfNeeded() {
    switch self.userLocationAuthorization {
    case .denied:
      self.view?.showDeniedLocationAuthorizationAlert()
    case .restricted:
      self.view?.showGloballyDeniedLocationAuthorizationAlert()
    case .notDetermined,
         .authorized:
      break
    }
  }

  // MARK: - Store subscriber

  public func newState(state: AppState) {
    defer { self.previousState = state }

    self.centerMapIfNeeded(newState: state)
    self.handleVehicleLocationChangeIfNeeded(newState: state)
  }

  // Center map:
  // - starting app (old is 'nil')
  //   - if we are 'authorized' -> center on user location
  //   - if we are not 'authorized' -> center on default location
  // - user just authorized app (old is 'notDetermined', new is 'authorized')
  //   -> center on user location
  private func centerMapIfNeeded(newState: AppState) {
    func centerOnUserLocation() {
      _ = self.environment.userLocation.getCurrent().done { [weak self] location in
        self?.view?.setCenter(location: location)
      }
    }

    let new = newState.userData.userLocationAuthorization

    guard let previousState = self.previousState else {
      switch new {
      case .authorized:
        centerOnUserLocation()
      case .notDetermined, .denied, .restricted:
        self.view?.setCenter(location: Defaults.location)
      }

      return
    }

    let old = previousState.userData.userLocationAuthorization

    if old.isNotDetermined && new.isAuthorized {
      centerOnUserLocation()
    }
  }

  // On vehicle response:
  // - if data -> update map
  // - if error -> show alert
  private func handleVehicleLocationChangeIfNeeded(newState: AppState) {
    let new = newState.apiData.vehicleLocations
    let old = self.previousState?.apiData.vehicleLocations

    switch new {
    case .none,
         .inProgress:
      break // Leave map exactly as it is.

    case .data(let vehicles):
      let oldVehicles = old?.getData()
      if vehicles != oldVehicles {
        self.view?.updateVehicleLocations(vehicles: vehicles)
      }

    case .error(let newError):
      // If previously we did not have an error -> just show new error
      guard let oldError = old?.getError() else {
        self.view?.showApiErrorAlert(error: newError)
        return
      }

      // Otherwise we have to check if error changed
      switch (oldError, newError) {
        case (.invalidResponse, .invalidResponse),
             (.reachabilityError, .reachabilityError),
             (.otherError, .otherError):
        break

      default:
        self.view?.showApiErrorAlert(error: newError)
      }
    }
  }
}
