//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import MapKit

fileprivate typealias Constants = LocationManagerConstants

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


  //MARK: - Initial region

  func getInitialRegion() -> MKCoordinateRegion {
    let center = self.locationManager.location?.coordinate ?? Constants.Default.location
    let size = Constants.Default.regionSize
    return MKCoordinateRegionMakeWithDistance(center, size, size)
  }

  //MARK: - Authorization

  var authorizationStatus: CLAuthorizationStatus {
    return CLLocationManager.authorizationStatus()
  }

  func requestInUseAuthorization() {
    self.locationManager.requestWhenInUseAuthorization()
  }

  func showAlertForDeniedAuthorization(in parent: UIViewController) {
    let alertTitle      = "Location access is disabled"
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

    parent.present(alertController, animated: true, completion: nil)
  }

  func showAlertForRestrictedAuthorization(in parent: UIViewController) {
    let alertTitle      = "Location access is disabled"
    let alertMessage    = "You can enable location access in your device settings."
    let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)

    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
    alertController.addAction(okAction)

    parent.present(alertController, animated: true, completion: nil)
  }

}
