//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import UIKit
import MapKit
import ReSwift

class MapViewController: UIViewController {

  //MARK: - Properties

  fileprivate var state = AppState()

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

    self.mapView.delegate = self

    self.requestInUseAuthorizationIfNeeded()
    let center = self.locationManager.location?.coordinate ?? CLLocationCoordinate2D(latitude: 51.109524, longitude: 17.032564)
    mapView.region = MKCoordinateRegionMakeWithDistance(center, 2500.0, 2500.0)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    store.subscribe(self)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    store.unsubscribe(self)
  }

}

//MARK: - StoreSubscriber

extension MapViewController: StoreSubscriber {

  func newState(state: AppState) {
    if self.state.trackingMode != state.trackingMode {
      self.mapView.setUserTrackingMode(state.trackingMode, animated: true)
    }

    //finally at the end update remembered state
    self.state = state
  }

}

//MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
    if mode != self.state.trackingMode {
      store.dispatch(SetUserTrackingMode(mode))
    }
  }
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
