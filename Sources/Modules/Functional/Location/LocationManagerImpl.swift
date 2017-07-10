//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import MapKit

fileprivate typealias Constants = LocationManagerConstants

class LocationManagerImpl: LocationManager {

  // MARK: - Properties

  private lazy var locationManager: CLLocationManager = {
    let locationManager = CLLocationManager()
    locationManager.distanceFilter  = Constants.Tracking.distanceFilter
    locationManager.desiredAccuracy = Constants.Tracking.accuracy
    locationManager.pausesLocationUpdatesAutomatically = true
    return locationManager
  }()

  // MARK: - LocationManager

  func getCenter() -> MKCoordinateRegion {
    let center = self.locationManager.location?.coordinate ?? Constants.Default.location
    let size   = Constants.Default.regionSize
    return MKCoordinateRegionMakeWithDistance(center, size, size)
  }

  var authorizationStatus: CLAuthorizationStatus {
    return CLLocationManager.authorizationStatus()
  }

  func requestInUseAuthorization() {
    self.locationManager.requestWhenInUseAuthorization()
  }

}
