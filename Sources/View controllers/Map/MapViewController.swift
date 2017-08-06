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
    firstly { () -> Promise<Void> in
      Managers.map.requestInUseAuthorization()
      return Promise(value: ())
    }
    .then { return Managers.map.getDefaultRegion() }
    .then { self.mapView.setRegion($0, animated: false) }
  }

  override var bottomLayoutGuide: UILayoutSupport {
    return LayoutGuide(length: 44.0)
  }

  // MARK: - Vehicle locations

  func updateVehicleLocations(_ vehicleLocations: [VehicleLocation]) {
    // remove annotations
    let annotationsBeforeRemoval = self.vehicleAnnotationsFromMap()

    let toRemoveCount = annotationsBeforeRemoval.count - vehicleLocations.count
    if toRemoveCount > 0 {
      let annotationsToRemove = Array(annotationsBeforeRemoval.prefix(toRemoveCount))
      self.mapView.removeAnnotations(annotationsToRemove)
    }

    // update/add annotations
    let annotationsAfterRemoval = self.vehicleAnnotationsFromMap()

    var annotationsToAdd = [VehicleLocationAnnotation]()
    for (index, vehicleLocation) in vehicleLocations.enumerated() {
      if index < annotationsAfterRemoval.count {
        let annotation = annotationsAfterRemoval[index]
        annotation.fillFrom(vehicleLocation)

        // redraw view if it is visible
        let annotationView = self.mapView.view(for: annotation) as? VehicleLocationAnnotationView
        annotationView?.redraw()
      }
      else {
        let vehicleAnnotation = VehicleLocationAnnotation(from: vehicleLocation)
        annotationsToAdd.append(vehicleAnnotation)
      }
    }

    if annotationsToAdd.count > 0 {
      self.mapView.addAnnotations(annotationsToAdd)
    }
  }

  private func vehicleAnnotationsFromMap() -> [VehicleLocationAnnotation] {
    return self.mapView.annotations
      .flatMap { return $0 as? VehicleLocationAnnotation }
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
    switch annotation {
    case let userLocation as MKUserLocation:
      userLocation.title    = nil
      userLocation.subtitle = nil
      return nil

    case let vehicleLocationAnnotation as VehicleLocationAnnotation:
      let identifier = "VehicleLocationAnnotationView"

      if let dequeuedView = self.mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? VehicleLocationAnnotationView {
        dequeuedView.setVehicleLocationAnnotation(vehicleLocationAnnotation)
        return dequeuedView
      }

      return VehicleLocationAnnotationView(vehicleLocation: vehicleLocationAnnotation, reuseIdentifier: identifier)

    default:
      return nil
    }
  }

}
