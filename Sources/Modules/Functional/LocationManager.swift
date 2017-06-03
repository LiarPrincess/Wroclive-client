//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
import MapKit

//MARK: - Protocol

protocol LocationManagerProtocol {
  func getInitialRegion() -> MKCoordinateRegion
  func requestInUseAuthorization()


  // start / stop
  // optional public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)

}

//MARK: - Constants

fileprivate struct LocationManagerConstants {

  struct Tracking {
    static let distanceFilter: CLLocationDistance = 5.0
    static let accuracy:       CLLocationAccuracy = kCLLocationAccuracyNearestTenMeters
  }

  struct Default {
    static let location   = CLLocationCoordinate2D(latitude: 51.109524, longitude: 17.032564)
    static let regionSize = CLLocationDistance(5000.0)
  }

}

fileprivate typealias Constants = LocationManagerConstants

//MARK: - Implementation

class LocationManager {

  //MARK: - Singleton

  static let instance: LocationManagerProtocol = LocationManager()

  //MARK: - Properties

  fileprivate lazy var locationManager: CLLocationManager = {
    let locationManager = CLLocationManager()
    locationManager.distanceFilter  = Constants.Tracking.distanceFilter
    locationManager.desiredAccuracy = Constants.Tracking.accuracy
    locationManager.pausesLocationUpdatesAutomatically = true
    return locationManager
  }()

}

//MARK: - LocationManagerProtocol

extension LocationManager: LocationManagerProtocol {

  //MARK: - Protocol

  func getInitialRegion() -> MKCoordinateRegion {
    let center = self.locationManager.location?.coordinate ?? Constants.Default.location
    let size = Constants.Default.regionSize
    return MKCoordinateRegionMakeWithDistance(center, size, size)
  }

  func requestInUseAuthorization() {
    let authorizationStatus = CLLocationManager.authorizationStatus()

    let isAuthorizationDenied = authorizationStatus == .denied || authorizationStatus == .restricted
    if isAuthorizationDenied {
      self.showChangeAuthorizationAlert()
      return
    }

    let isAuthorizationAllowed = authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways
    if isAuthorizationAllowed {
      return
    }

    self.locationManager.requestWhenInUseAuthorization()
  }

  //MARK: - Methods

  func showChangeAuthorizationAlert() {
    let alertTitle      = "Background location access is disabled"
    let alertMessage    = "In order show your current location, please open this app settings and set location access to 'In use'."
    let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
  
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    alertController.addAction(cancelAction)
  
    let openAction = UIAlertAction(title: "Open Settings", style: .default) { action in
      if let url = URL(string: UIApplicationOpenSettingsURLString) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
      }
    }
    alertController.addAction(openAction)


  //  self.present(alertController, animated: true, completion: nil)
  }

}
