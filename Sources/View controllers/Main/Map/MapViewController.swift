//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import MapKit
import SnapKit
import RxSwift

private typealias Pin      = MapViewControllerConstants.Pin
private typealias Defaults = MapViewControllerConstants.Defaults

class MapViewController: UIViewController {

  // MARK: - Properties

  let mapView = MKMapView()

  private let viewModel: MapViewModelType = MapViewModel()
  private let disposeBag = DisposeBag()

  // MARK: - Init

  convenience init() {
    self.init(nibName: nil, bundle: nil)
  }

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nil, bundle: nil)
    self.insetViewToShowMapLegalInfo()

    self.initMapBindings()
    self.initLiveBindings()
    self.initAlertBindings()
    self.initViewControlerLifecycleBindings()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Bindings

  private func initMapBindings() {
    self.rx.methodInvoked(#selector(MKMapViewDelegate.mapView(_:didChange:animated:)))
      .map { [unowned self] _ in self.mapView.userTrackingMode }
      .bind(to: self.viewModel.inputs.trackingModeChanged)
      .disposed(by: self.disposeBag)

    self.viewModel.outputs.mapType
      .drive(self.mapView.rx.mapType)
      .disposed(by: self.disposeBag)

    self.viewModel.outputs.mapCenter
      .drive(onNext: { [unowned self] in self.setMapCenter($0, Defaults.zoom, animated: true) })
      .disposed(by: self.disposeBag)
  }

  private func initLiveBindings() {
    self.viewModel.outputs.vehicleLocations
      .drive(onNext: { [unowned self] in self.updateVehicleLocations($0) })
      .disposed(by: self.disposeBag)
  }

  private func initAlertBindings() {
    self.viewModel.outputs.showLocationAuthorizationAlert
      .drive(onNext: { _ in Managers.userLocation.requestWhenInUseAuthorization() })
      .disposed(by: self.disposeBag)

    self.viewModel.outputs.showDeniedLocationAuthorizationAlert.asObservable()
      .flatMapLatest(createDeniedLocalizationAuthorizationAlert)
      .subscribe()
      .disposed(by: self.disposeBag)

    self.viewModel.outputs.showApiErrorAlert.asObservable()
      .flatMapLatest(createApiErrorAlert)
      .subscribe()
      .disposed(by: self.disposeBag)
  }

  private func initViewControlerLifecycleBindings() {
    // simple binding would propagate also .onCompleted events
    self.rx.methodInvoked(#selector(MapViewController.viewDidAppear(_:)))
      .take(1)
      .bind { [weak self] _ in self?.viewModel.inputs.viewDidAppear.onNext() }
      .disposed(by: self.disposeBag)
  }

  // MARK: - Overriden

  override func viewDidLoad() {
    super.viewDidLoad()

    self.mapView.showsScale        = false
    self.mapView.showsTraffic      = false
    self.mapView.showsBuildings    = true
    self.mapView.showsCompass      = true
    self.mapView.showsUserLocation = true
    self.mapView.isRotateEnabled   = false
    self.mapView.isPitchEnabled    = false

    self.mapView.delegate = self

    self.view.addSubview(self.mapView)
    self.mapView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

  // MARK: - Map legal info

  // iOS 10
  override var bottomLayoutGuide: UILayoutSupport {
    return LayoutGuide(length: 44.0)
  }

  // iOS 11
  private func insetViewToShowMapLegalInfo() {
    if #available(iOS 11, *) {
      let insets = self.additionalSafeAreaInsets
      self.additionalSafeAreaInsets.bottom = max(insets.bottom, self.bottomLayoutGuide.length)
    }
  }

  // MARK: - Map

  private func setMapCenter(_ center: CLLocationCoordinate2D, _ radius: CLLocationDistance, animated: Bool) {
    let currentCenter = self.mapView.centerCoordinate
    let distance      = currentCenter.distance(from: center)

    if distance > 10.0 { // meters
      let region = MKCoordinateRegionMakeWithDistance(center, 2 * radius, 2 * radius)
      self.mapView.setRegion(region, animated: animated)
    }
  }
}

// MARK: - Annotations

extension MapViewController {

  private var vehicleAnnotations: [VehicleAnnotation] {
    return self.mapView.annotations.flatMap { $0 as? VehicleAnnotation }
  }

  private func updateVehicleLocations(_ vehicles: [Vehicle]) {
    let updates = MapAnnotationManager.calculateUpdates(for: self.vehicleAnnotations, with: vehicles)

    self.mapView.addAnnotations(updates.createdAnnotations)
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

  func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
    // empty, just so we can use bindings
  }
}

// MARK: - Helpers

private func createDeniedLocalizationAuthorizationAlert(_ alert: DeniedLocationAuthorizationAlert) -> Observable<Void> {
  switch alert {
  case .deniedLocationAuthorization:
    return LocationAlerts.showDeniedLocationAuthorizationAlert()
  case .globallyDeniedLocationAuthorization:
    return LocationAlerts.showGloballyDeniedLocationAuthorizationAlert()
  }
}

private func createApiErrorAlert(_ error: ApiError) -> Observable<Void> {
  switch error {
  case .noInternet:      return NetworkAlerts.showNoInternetAlert()
  case .invalidResponse,
       .generalError:    return NetworkAlerts.showConnectionErrorAlert()
  }
}
