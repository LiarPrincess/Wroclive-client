//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import MapKit
import SnapKit
import PromiseKit

private typealias Constants = MapViewControllerConstants

class MapViewController: UIViewController {

  // MARK: - Properties

  var mapView: MKMapView = {
    let result = MKMapView()
    result.mapType           = Constants.MapView.mapType
    result.showsBuildings    = Constants.MapView.showsBuildings
    result.showsCompass      = Constants.MapView.showsCompass
    result.showsScale        = Constants.MapView.showsScale
    result.showsTraffic      = Constants.MapView.showsTraffic
    result.showsUserLocation = Constants.MapView.showsUserLocation
    return result
  }()

  // MARK: - Overriden

  override func viewDidLoad() {
    super.viewDidLoad()

    self.mapView.delegate = self
    self.view.addSubview(self.mapView)

    self.mapView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    _ = firstly { () -> Promise<Void> in
      Managers.location.requestInUseAuthorization()
      return Promise(value: ())
    }
    .then { return Managers.location.getDefaultRegion() }
    .then { self.mapView.setRegion($0, animated: false) }
  }

  override var bottomLayoutGuide: UILayoutSupport {
    return LayoutGuide(length: 44.0)
  }

  // MARK: - Vehicle locations

  func updateVehicleLocations(_ vehicles: [Vehicle]) {
    // remove excess annotations
    let annotationsBeforeRemoval = self.filterVehicleAnnotations()

    let toRemoveCount = annotationsBeforeRemoval.count - vehicles.count
    if toRemoveCount > 0 {
      let annotationsToRemove = Array(annotationsBeforeRemoval.prefix(toRemoveCount))
      self.mapView.removeAnnotations(annotationsToRemove)
    }

    // update/add annotations
    let annotations = self.filterVehicleAnnotations() // after we removed

    var annotationsToAdd = [VehicleAnnotation]()
    for (index, vehicle) in vehicles.enumerated() {
      if index < annotations.count {
        let annotation = annotations[index]
        annotation.fillFrom(vehicle)

        // redraw view if it is visible
        let annotationView = self.mapView.view(for: annotation) as? VehicleAnnotationView
        annotationView?.redraw()
      }
      else {
        let vehicleAnnotation = VehicleAnnotation(from: vehicle)
        annotationsToAdd.append(vehicleAnnotation)
      }
    }

    if annotationsToAdd.count > 0 {
      self.mapView.addAnnotations(annotationsToAdd)
    }
  }

  private func filterVehicleAnnotations() -> [VehicleAnnotation] {
    return self.mapView.annotations.flatMap { return $0 as? VehicleAnnotation }
  }
}

// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {

  // MARK: - Tracking mode

  func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
    let authorizationStatus = Managers.location.authorizationStatus

    if authorizationStatus == .denied {
      Managers.alert.showDeniedLocationAuthorizationAlert(in: self)
    }

    if authorizationStatus == .restricted {
      Managers.alert.showGloballyDeniedLocationAuthorizationAlert(in: self)
    }
  }

  // MARK: - Annotations

  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    switch annotation {
    case let userLocation as MKUserLocation:
      userLocation.title    = nil
      userLocation.subtitle = nil
      return nil

    case let vehicleAnnotation as VehicleAnnotation:
      let identifier = "VehicleAnnotationView"

      if let dequeuedView = self.mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? VehicleAnnotationView {
        dequeuedView.setVehicleAnnotation(vehicleAnnotation)
        return dequeuedView
      }

      return VehicleAnnotationView(vehicleAnnotation, reuseIdentifier: identifier)

    default:
      return nil
    }
  }
}
