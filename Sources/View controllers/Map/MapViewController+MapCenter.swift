//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import MapKit
import PromiseKit

private typealias Constants = MapViewControllerConstants

extension MapViewController {

  func centerDefaultRegion(animated: Bool) {
    typealias Defaults = Constants.Defaults

    let newCenter = Defaults.cityCenter
    let oldCenter = self.mapView.region.center

    let minDegChangeToUpdate = Constants.Defaults.minDegChangeToUpdate
    let hasLatitudeChanged  = abs(newCenter.latitude - oldCenter.latitude) > minDegChangeToUpdate
    let hasLongitudeChanged = abs(newCenter.longitude - oldCenter.longitude) > minDegChangeToUpdate

    // Prevent min flicker when we set the same center 2nd time
    if hasLatitudeChanged || hasLongitudeChanged {
      let newRegion = MKCoordinateRegionMakeWithDistance(newCenter, Defaults.regionSize, Defaults.regionSize)
      self.mapView.setRegion(newRegion, animated: animated)
    }
  }

  func centerUserLocationIfAuthorized(animated: Bool) {
    let authorization = Managers.location.authorization

    guard authorization == .authorizedAlways || authorization == .authorizedWhenInUse
      else { return }

    _ = Managers.location.getCurrent()
      .then { userLocation -> () in
        self.mapView.setCenter(userLocation, animated: true)
        self.alertWhenFarFromDefaultCity(userLocation: userLocation)
        return ()
      }
      // if we don't have access then leave as it is
      .catch { _ in () }
  }

  private func alertWhenFarFromDefaultCity(userLocation: CLLocationCoordinate2D) {
    let cityCenter = CLLocation(coordinate: Constants.Defaults.cityCenter)
    let distance   = cityCenter.distance(from: CLLocation(coordinate: userLocation))

    guard distance > Constants.Defaults.cityRadius
      else { return }

    Managers.alert.showInvalidCityAlert(in: self) { [weak self] result in
      if result == .showDefault {
        self?.centerDefaultRegion(animated: true)
      }
    }
  }
}
