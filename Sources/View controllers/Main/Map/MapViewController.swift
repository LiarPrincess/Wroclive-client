//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import MapKit
import SnapKit
import PromiseKit
import RxSwift

private typealias Constants = MapViewControllerConstants

class MapViewController: UIViewController {

  // MARK: - Properties

  let mapView = MKMapView()
  private let disposeBag = DisposeBag()

  // MARK: - Init

  convenience init() {
    self.init(nibName: nil, bundle: nil)
  }

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nil, bundle: nil)
    self.insetViewToShowMapLegalInfo()
    self.startObservingColorScheme()
    self.startObservingLocationAuthorization()

    self.initMapBindings()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    self.stopObservingColorScheme()
    self.stopObservingLocationAuthorization()
  }

  // MARK: - Bindings

  private func initMapBindings() {
    Managers.map.mapType
      .map(toMKMapType)
      .asDriver(onErrorDriveWith: .never())
      .drive(self.mapView.rx.mapType)
      .disposed(by: self.disposeBag)

    Managers.map.vehicleLocations
      .values()
      .bind { [unowned self] in self.updateVehicleLocations($0) }
      .disposed(by: self.disposeBag)

    Managers.map.vehicleLocations
      .errors()
      .flatMapLatest(createAlert)
      .subscribe()
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
    self.mapView.delegate          = self

    self.centerDefaultLocation(animated: false)

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

  // MARK: Annotations

  private func getVehicleAnnotations() -> [VehicleAnnotation] {
    return self.mapView.annotations.flatMap { $0 as? VehicleAnnotation }
  }

  private func updateVehicleLocations(_ vehicles: [Vehicle]) {
    let annotations = self.getVehicleAnnotations()
    let updates     = MapAnnotationManager.calculateUpdates(for: annotations, with: vehicles)

    // updated
    UIView.animate(withDuration: Constants.Pin.animationDuration) {
      for (vehicle, annotation) in updates.updatedAnnotations {
        annotation.angle      = CGFloat(vehicle.angle)
        annotation.coordinate = CLLocationCoordinate2D(latitude: vehicle.latitude, longitude: vehicle.longitude)

        if let annotationView = self.mapView.view(for: annotation) as? VehicleAnnotationView {
          annotationView.updateImage()
        }
      }
    }

    // created, removed
    self.mapView.addAnnotations(updates.createdAnnotations)
    self.mapView.removeAnnotations(updates.removedAnnotations)
  }
}

// MARK: - Notifications

extension MapViewController: ColorSchemeObserver, LocationAuthorizationObserver {

  func colorSchemeDidChange() {
    for annotation in self.getVehicleAnnotations() {
      if let annotationView = self.mapView.view(for: annotation) as? VehicleAnnotationView {
        annotationView.updateImage()
        annotationView.updateLabel()
      }
    }
  }

  // called also on app startup
  func locationAuthorizationDidChange() {
    self.centerDefaultLocation(animated: true)
  }
}

// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {

  // MARK: - Tracking mode

  func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
    let authorization = Managers.userLocation.authorization
    switch authorization {
    case .denied:        LocationAlerts.showDeniedLocationAuthorizationAlert(in: self)
    case .restricted:    LocationAlerts.showGloballyDeniedLocationAuthorizationAlert(in: self)
    case .notDetermined: Managers.userLocation.requestAuthorization()
    default: break
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

// MARK: - Helpers

private func toMKMapType(_ mapType: MapType) -> MKMapType {
  switch mapType {
  case .standard:  return .standard
  case .satellite: return .satellite
  case .hybrid:    return .hybrid
  }
}

private func createAlert(_ error: ApiError) -> Observable<Void> {
  switch error {
  case .noInternet:      return NetworkAlerts.showNoInternetAlert()
  case .invalidResponse,
       .generalError:    return NetworkAlerts.showConnectionErrorAlert()
  }
}
