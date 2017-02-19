//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

  //MARK: - Properties

  fileprivate lazy var locationManager: CLLocationManager = {
    let locationManager = CLLocationManager()
    locationManager.distanceFilter = 5.0
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    return locationManager
  }()

  @IBOutlet weak var mapView: MKMapView!

  //MARK: - Overriden

  override func viewDidLoad() {
    super.viewDidLoad()

    let center = self.locationManager.location?.coordinate ?? CLLocationCoordinate2D(latitude: 51.109524, longitude: 17.032564)
    mapView.region = MKCoordinateRegionMakeWithDistance(center, 2500.0, 2500.0)
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    self.requestInUseAuthorizationIfNeeded()
  }

  //MARK: - Methods

}

//MARK: - MapKit

extension MapViewController {

  //MARK: - Authorization

  func requestInUseAuthorizationIfNeeded() {
    let authorizationStatus = self.locationManager.authorizationStatus

    guard !authorizationStatus.forbidsLocalization else {
      print("Location services were forbidden by user.")
      return
    }

    guard authorizationStatus == .notDetermined else {
      print("Location services permissions already granted")
      return
    }

    self.locationManager.requestWhenInUseAuthorization()
  }

  func presentAlertToChangeAuthorization() {
    let alertTitle = "Background location access is disabled"
    let alertMessage = "In order show your current location, please open this app's settings and set location access to 'In use'."
    let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)

    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    alertController.addAction(cancelAction)

    let openAction = UIAlertAction(title: "Open Settings", style: .default) { action in
      if let url = URL(string: UIApplicationOpenSettingsURLString) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
      }
    }
    alertController.addAction(openAction)

    self.present(alertController, animated: true, completion: nil)
  }

}
