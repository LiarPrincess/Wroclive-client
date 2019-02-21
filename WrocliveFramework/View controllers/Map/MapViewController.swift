// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import MapKit
import RxSwift
import RxCocoa

private typealias Pin      = MapViewControllerConstants.Pin
private typealias Defaults = MapViewControllerConstants.Defaults

public final class MapViewController: UIViewController {

  // MARK: - Properties

  public let mapView = MKMapView()

  private let viewModel: MapViewModel
  private let disposeBag = DisposeBag()

  // MARK: - Init

  public init(_ viewModel: MapViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    self.initBindings()
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Bindings

  private func initBindings() {
    // map
    self.rx.methodInvoked(#selector(MKMapViewDelegate.mapView(_:didChange:animated:)))
      .map { [unowned self] _ in self.mapView.userTrackingMode }
      .bind(to: self.viewModel.didChangeTrackingMode)
      .disposed(by: self.disposeBag)

    self.viewModel.mapCenter
      .drive(onNext: { [unowned self] in self.setMapCenter($0, Defaults.zoom, animated: true) })
      .disposed(by: self.disposeBag)

    // annotations
    self.viewModel.vehicleLocations
      .drive(onNext: { [unowned self] in self.updateVehicleLocations($0) })
      .disposed(by: self.disposeBag)

    // alert
    self.viewModel.showAlert
      .filter { $0 == .requestLocationAuthorization }
      .drive(onNext: { _ in AppEnvironment.userLocation.requestWhenInUseAuthorization() })
      .disposed(by: self.disposeBag)

    self.viewModel.showAlert.asObservable()
      .flatMapLatest(createAlert)
      .subscribe()
      .disposed(by: self.disposeBag)

    // view controler lifecycle
    // simple binding would propagate also .onCompleted events
    self.rx.methodInvoked(#selector(MapViewController.viewDidAppear(_:)))
      .take(1)
      .bind { [weak self] _ in self?.viewModel.viewDidAppear.onNext() }
      .disposed(by: self.disposeBag)
  }

  // MARK: - Overriden

  public override func viewDidLoad() {
    super.viewDidLoad()

    self.mapView.showsScale        = false
    self.mapView.showsTraffic      = false
    self.mapView.showsBuildings    = true
    self.mapView.showsCompass      = true
    self.mapView.showsUserLocation = true
    self.mapView.isRotateEnabled   = true
    self.mapView.isPitchEnabled    = false
    self.mapView.mapType           = .standard

    self.mapView.delegate = self

    self.view.addSubview(self.mapView, constraints: makeEdgesEqualToSuperview())
  }

  // MARK: - Map

  private func setMapCenter(_ center: CLLocationCoordinate2D, _ radius: CLLocationDistance, animated: Bool) {
    let currentCenter = self.mapView.centerCoordinate
    let distance      = currentCenter.distance(from: center)

    if distance > 10.0 { // meters
      let region = MKCoordinateRegion(center: center, latitudinalMeters: 2 * radius, longitudinalMeters: 2 * radius)
      self.mapView.setRegion(region, animated: animated)
    }
  }
}

// MARK: - Annotations

public extension MapViewController {

  private var vehicleAnnotations: [VehicleAnnotation] {
    return self.mapView.annotations.compactMap { $0 as? VehicleAnnotation }
  }

  private func updateVehicleLocations(_ vehicles: [Vehicle]) {
    let updates = VehicleAnnotationUpdater.calculateUpdates(for: self.vehicleAnnotations, from: vehicles)

    self.mapView.addAnnotations(updates.newAnnotations)
    self.mapView.removeAnnotations(updates.removedAnnotations)

    UIView.animate(withDuration: Pin.animationDuration) {
      for (vehicle, annotation) in updates.updatedAnnotations {
        annotation.angle      = CGFloat(vehicle.angle)
        annotation.coordinate = CLLocationCoordinate2D(latitude: vehicle.latitude, longitude: vehicle.longitude)

        let annotationView = self.mapView.view(for: annotation) as? VehicleAnnotationView
        annotationView?.updateImage()
      }
    }
  }
}

// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {

  public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
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

  public func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
    // empty, just so we can use bindings
  }
}

// MARK: - Helpers

private func createAlert(_ alert: MapViewAlert) -> Observable<Void> {
  switch alert {
  case .deniedLocationAuthorization:
    return LocationAlerts.showDeniedLocationAuthorizationAlert()
  case .globallyDeniedLocationAuthorization:
    return LocationAlerts.showGloballyDeniedLocationAuthorizationAlert()
  case let .apiError(error):
    switch error {
    case .noInternet:      return NetworkAlerts.showNoInternetAlert()
    case .invalidResponse,
         .generalError:    return NetworkAlerts.showConnectionErrorAlert()
    }
  case .requestLocationAuthorization:
      return .never()
  }
}
