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
    let annotationsBeforeRemoval = self.getVehicleAnnotationsFromMap()

    let toRemoveCount = annotationsBeforeRemoval.count - vehicleLocations.count
    if toRemoveCount > 0 {
      let annotationsToRemove = Array(annotationsBeforeRemoval.prefix(toRemoveCount))
      self.mapView.removeAnnotations(annotationsToRemove)
    }

    // update/add annotations
    let annotationsAfterRemoval = self.getVehicleAnnotationsFromMap()

    var annotationsToAdd = [VehicleLocationAnnotation]()
    for (index, vehicleLocation) in vehicleLocations.enumerated() {
      if index < annotationsAfterRemoval.count {
        annotationsAfterRemoval[index].fillFrom(vehicleLocation: vehicleLocation)
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

  private func getVehicleAnnotationsFromMap() -> [VehicleLocationAnnotation] {
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

    case let vehicleLocation as VehicleLocationAnnotation:
      return self.createVehicleLocationAnnotation(vehicleLocation)

    default:
      return nil
    }
  }

  private func createVehicleLocationAnnotation(_ annotation: VehicleLocationAnnotation) -> MKAnnotationView? {
    let identifier = "VehicleLocationAnnotation"

    if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
      dequeuedView.annotation = annotation
//      dequeuedView.transform = CGAffineTransform(rotationAngle: CGFloat(vehicleLocation.angle))
      return dequeuedView
    }

    let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier) // MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
    annotationView.isDraggable    = false
    annotationView.canShowCallout = false
    annotationView.annotation     = annotation
//    view.image = #imageLiteral(resourceName: "mapPin")
//    view.transform = CGAffineTransform(rotationAngle: CGFloat(vehicleLocation.angle))

    return annotationView
  }

}
