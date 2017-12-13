//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import MapKit
import PromiseKit

private typealias Constants = MapViewControllerConstants

extension MapViewController {

  func centerDefaultLocation(animated: Bool) {
    let authorization = Managers.location.authorization

    let isAuthorized = authorization == .authorizedAlways || authorization == .authorizedWhenInUse
    if isAuthorized {
      self.centerUserLocation(animated: animated)
    }
    else {
      self.centerCityCenter(animated: animated)
    }
  }

  func centerUserLocation(animated: Bool) {
    _ = Managers.location.getCurrent()
      .then { userLocation -> () in
        self.setMapCenter(userLocation, animated: animated)
        self.alertWhenFarFromDefaultCity(userLocation: userLocation)
        return ()
      }
      .catch { _ in
        self.centerCityCenter(animated: animated)
      }
  }

  private func centerCityCenter(animated: Bool) {
    typealias Defaults = Constants.Defaults

    let newCenter = Defaults.cityCenter
    let oldCenter = self.mapView.region.center

    let minDegChangeToUpdate = Constants.Defaults.minDegChangeToUpdate
    let hasLatitudeChanged  = abs(newCenter.latitude - oldCenter.latitude) > minDegChangeToUpdate
    let hasLongitudeChanged = abs(newCenter.longitude - oldCenter.longitude) > minDegChangeToUpdate

    // Prevent min flicker when we set the same center 2nd time
    if hasLatitudeChanged || hasLongitudeChanged {
      self.setMapCenter(newCenter, animated: animated)
    }
  }

  private func setMapCenter(_ center: CLLocationCoordinate2D, animated: Bool) {
    typealias Defaults = Constants.Defaults
    let region = MKCoordinateRegionMakeWithDistance(center, Defaults.regionSize, Defaults.regionSize)
    self.mapView.setRegion(region, animated: animated)
  }

  private func alertWhenFarFromDefaultCity(userLocation: CLLocationCoordinate2D) {
    let cityCenter = CLLocation(coordinate: Constants.Defaults.cityCenter)
    let distance   = cityCenter.distance(from: CLLocation(coordinate: userLocation))

    guard distance > Constants.Defaults.cityRadius
      else { return }

    LocationAlerts.showInvalidCityAlert(in: self) { [weak self] result in
      if result == .showDefault {
        self?.centerCityCenter(animated: true)
      }
    }
  }
}
