// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import MapKit
import SnapKit

private typealias Pin = MapViewController.Constants.Pin
private typealias Defaults = MapViewController.Constants.Defaults

public final class MapViewController:
  UIViewController, MKMapViewDelegate, MapViewType {

  // MARK: - Properties

  public let mapView = MKMapView()

  private let viewModel: MapViewModel

  // MARK: - Init

  public init(viewModel: MapViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    viewModel.setView(view: self)
  }

  // swiftlint:disable:next unavailable_function
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Overriden

  override public func viewDidLoad() {
    super.viewDidLoad()

    // Generally usefull.
    self.mapView.showsScale = true
    self.mapView.showsBuildings = true
    self.mapView.showsUserLocation = true
    // Usefull for arrival estimation.
    self.mapView.showsTraffic = true
    // Beeing able to zoom is kind of 'the thing' in this app.
    self.mapView.isPitchEnabled = false
    // We have to disable rotation, because that would require us to rotate
    // annotations (which is hard to implement and can make people dizzy).
    self.mapView.isRotateEnabled = false
    // Not needed since we can't rotate.
    self.mapView.showsCompass = false
    self.mapView.mapType = .standard

    self.mapView.delegate = self

    self.view.addSubview(self.mapView)
    self.mapView.snp.makeConstraints { $0.edges.equalToSuperview() }
  }

  // MARK: - Center

  public func setCenter(location: CLLocationCoordinate2D, animated: Bool) {
    self.setCenter(location: location,
                   radius: Defaults.zoom,
                   animated: animated)
  }

  public func setCenter(location: CLLocationCoordinate2D,
                        radius: CLLocationDistance,
                        animated: Bool) {
    let currentCenter = self.mapView.centerCoordinate
    let distance = currentCenter.distance(from: location)

    // TODO: Move this to constants
    if distance > 10.0 { // meters
      let region = MKCoordinateRegion(center: location,
                                      latitudinalMeters: 2 * radius,
                                      longitudinalMeters: 2 * radius)
      self.mapView.setRegion(region, animated: animated)
    }
  }

  // MARK: - Annotations

  private var vehicleAnnotations: [VehicleAnnotation] {
    return self.mapView.annotations.compactMap { $0 as? VehicleAnnotation }
  }

  public func showVehicles(vehicles: [Vehicle]) {
    let diff = VehicleAnnotationDiff.calculate(annotations: self.vehicleAnnotations,
                                               vehicles: vehicles)

    self.mapView.addAnnotations(diff.added)
    self.mapView.removeAnnotations(diff.removed)

    UIView.animate(withDuration: Pin.animationDuration) {
      for (annotation, vehicle) in diff.updated {
        annotation.angle = CGFloat(vehicle.angle)
        annotation.coordinate = CLLocationCoordinate2D(latitude: vehicle.latitude,
                                                       longitude: vehicle.longitude)

        let annotationView = self.mapView.view(for: annotation) as? VehicleAnnotationView
        annotationView?.updateImage()
      }
    }
  }

  // MARK: - MKMapViewDelegate

  public func mapView(_ mapView: MKMapView,
                      viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    switch annotation {
    case let userLocation as MKUserLocation:
      userLocation.title = nil
      userLocation.subtitle = nil
      return nil

    case let vehicleAnnotation as VehicleAnnotation:
      let id = "VehicleAnnotationView"

      let genericView = self.mapView.dequeueReusableAnnotationView(withIdentifier: id)
      if let dequeuedView = genericView as? VehicleAnnotationView {
        dequeuedView.setVehicleAnnotation(vehicleAnnotation)
        return dequeuedView
      }

      return VehicleAnnotationView(annotation: vehicleAnnotation, reuseIdentifier: id)

    default:
      return nil
    }
  }

  public func mapView(_ mapView: MKMapView,
                      didChange mode: MKUserTrackingMode,
                      animated: Bool) {
    self.viewModel.didChangeTrackingMode(to: mode)
  }

  // MARK: - Alerts

  public func showDeniedLocationAuthorizationAlert() {
    _ = AlertCreator.showDeniedLocationAuthorizationAlert()
  }

  public func showGloballyDeniedLocationAuthorizationAlert() {
    _ = AlertCreator.showGloballyDeniedLocationAuthorizationAlert()
  }

  public func showApiErrorAlert(error: ApiError) {
    switch error {
    case .reachabilityError:
      _ = AlertCreator.showReachabilityAlert()
    case .invalidResponse,
         .otherError:
      _ = AlertCreator.showConnectionErrorAlert()
    }
  }
}
