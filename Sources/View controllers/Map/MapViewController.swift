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
      Managers.location.requestInUseAuthorization()
      return Promise(value: ())
    }
    .then { _ in return Managers.location.getCenter() }
    .then { center in self.mapView.setRegion(center, animated: false) }
  }

  override var bottomLayoutGuide: UILayoutSupport {
    return LayoutGuide(length: 44.0)
  }

  // MARK: - Vehicle locations

  func updateVehicleLocations(_ locations: [VehicleLocation]) {
    self.mapView.addAnnotations(locations)
  }

}

// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {

  // MARK: - Tracking mode

  func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
    let authorizationStatus = Managers.location.authorizationStatus

    if authorizationStatus == .denied {
      Managers.alert.showDeniedAuthorizationAlert(in: self)
    }

    if authorizationStatus == .restricted {
      Managers.alert.showRestrictedAuthorizationAlert(in: self)
    }
  }

  // MARK: - Annotations

  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    guard let vehicleLocation = annotation as? VehicleLocation else {
      return nil
    }

    let identifier = "vehicleLocation"
    if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
      dequeuedView.annotation = annotation
      return dequeuedView
    }

    let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
    view.animatesDrop = false
//    view.image = nil
    view.isDraggable = false
    return view
  }

}
