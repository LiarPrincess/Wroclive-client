//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import MapKit
import SnapKit
import PromiseKit

class MapViewController: UIViewController {

  // MARK: - Properties

  let mapView = MKMapView()

  // MARK: - Overriden

  override func viewDidLoad() {
    super.viewDidLoad()
    self.initLayout()
  }

  override func viewDidAppear(_ animated: Bool) {
    _ = firstly { () -> Promise<Void> in
      Managers.map.requestInUseAuthorization()
      return Promise(value: ())
    }
    .then { _ in return Managers.map.getDefaultRegion() }
    .then { center in self.mapView.setRegion(center, animated: false) }
  }

  override var bottomLayoutGuide: UILayoutSupport {
    return LayoutGuide(length: 44.0)
  }

  // MARK: - Vehicle locations

  func updateVehicleLocations(_ locations: [VehicleLocation]) {
    let mapAnnotations = self.mapView.annotations
    self.mapView.addAnnotations(locations)
  }

}

// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {

  // MARK: - Tracking mode

  func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
    let authorizationStatus = Managers.map.authorizationStatus

    if authorizationStatus == .denied {
      Managers.alert.showDeniedAuthorizationAlert(in: self)
    }

    if authorizationStatus == .restricted {
      Managers.alert.showRestrictedAuthorizationAlert(in: self)
    }
  }

  // MARK: - Annotations

  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    if let userLocationAnnotation = annotation as? MKUserLocation {
      self.customizeUserLocationAnnotation(userLocationAnnotation)
      return nil
    }

    if let vehicleLocation = annotation as? VehicleLocation {
      return self.createVehicleLocationAnnotation(vehicleLocation)
    }

    return nil
  }

  private func customizeUserLocationAnnotation(_ userLocationAnnotation: MKUserLocation) {
    userLocationAnnotation.title = nil
    userLocationAnnotation.subtitle = nil
  }

  private func createVehicleLocationAnnotation(_ vehicleLocation: VehicleLocation) -> MKAnnotationView? {
    let identifier = "vehicleLocation"

    if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
      dequeuedView.annotation = vehicleLocation
      return dequeuedView
    }

    let view = MKPinAnnotationView(annotation: vehicleLocation, reuseIdentifier: identifier)
    view.animatesDrop = false
    // view.image = nil
    view.isDraggable = false
    return view
  }

}
