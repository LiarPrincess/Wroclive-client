//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import Foundation
import MapKit

class MapKitHelper {

  private static let locationManager = CLLocationManager()

  //MARK: - Authorization

  static var authorizationStatus: CLAuthorizationStatus { return CLLocationManager.authorizationStatus() }

  static func requestInUseAuthorizationIfNeeded() {
    guard self.authorizationStatus != .restricted || self.authorizationStatus != .denied else {
      print("[LocationManager] Location service not available (status: '\(self.authorizationStatus)').")
      return
    }

    if authorizationStatus == .notDetermined {
      self.locationManager.requestWhenInUseAuthorization()
    }
  }

  static func presentAlertToChangeAuthorization(parent controller: UIViewController) {
    let alertTitle = "Background location access is disabled"
    let alertMessage = "In order show your current location, please open this app's settings and set location access to 'Always'."
    let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)

    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    alertController.addAction(cancelAction)

    let openAction = UIAlertAction(title: "Open Settings", style: .default) { action in
      if let url = URL(string: UIApplicationOpenSettingsURLString) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
      }
    }
    alertController.addAction(openAction)

    controller.present(alertController, animated: true, completion: nil)
  }

  //MARK: - Location

  static var currentLocation: CLLocation? { return locationManager.location }

}
