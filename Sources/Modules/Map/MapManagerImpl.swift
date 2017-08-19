//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import MapKit
import PromiseKit

fileprivate typealias Constants = MapManagerConstants

class MapManagerImpl: MapManager {

  // MARK: - Properties

  private lazy var locationManager: CLLocationManager = {
    let locationManager = CLLocationManager()
    locationManager.distanceFilter  = Constants.Tracking.distanceFilter
    locationManager.desiredAccuracy = Constants.Tracking.accuracy
    locationManager.pausesLocationUpdatesAutomatically = true
    return locationManager
  }()

  // MARK: - LocationManager

  func getDefaultRegion() -> Promise<MKCoordinateRegion> {
    return Promise { fulfill, _ in
      let center = self.locationManager.location?.coordinate ?? Constants.Default.location
      let size   = Constants.Default.regionSize
      fulfill(MKCoordinateRegionMakeWithDistance(center, size, size))
    }
  }

  var authorizationStatus: CLAuthorizationStatus {
    return CLLocationManager.authorizationStatus()
  }

  func requestInUseAuthorization() {
    self.locationManager.requestWhenInUseAuthorization()
  }

}
