//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import MapKit
import SnapKit
import PromiseKit

private typealias Constants = MapViewControllerConstants

class MapViewController: UIViewController, HasLocationManager, HasAlertManager, HasNotificationManager {

  typealias Dependencies = HasLocationManager & HasAlertManager & HasNotificationManager

  // MARK: - Properties

  let managers: Dependencies
  var location:     LocationManager     { return self.managers.location }
  var alert:        AlertManager        { return self.managers.alert }
  var notification: NotificationManager { return self.managers.notification }

  let mapView = MKMapView()

  // MARK: - Init

  convenience init(managers: Dependencies) {
    self.init(nibName: nil, bundle: nil, managers: managers)
  }

  init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, managers: Dependencies) {
    self.managers = managers
    super.init(nibName: nil, bundle: nil)
    self.insetViewToShowMapLegalInfo()
    self.startObservingApplicationActivity()
    self.startObservingLocationAuthorization()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    self.stopObservingApplicationActivity()
    self.stopObservingLocationAuthorization()
  }

  // MARK: - Overriden

  override func viewDidLoad() {
    super.viewDidLoad()

    self.mapView.mapType           = .standard
    self.mapView.showsScale        = false
    self.mapView.showsTraffic      = false
    self.mapView.showsBuildings    = true
    self.mapView.showsCompass      = true
    self.mapView.showsUserLocation = true
    self.mapView.delegate          = self

    self.centerDefaultRegion(animated: false)

    self.view.addSubview(self.mapView)
    self.mapView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.centerUserLocationIfAuthorized(animated: true)
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

  // MARK: - Map management

  fileprivate func centerDefaultRegion(animated: Bool) {
    typealias Defaults = Constants.Defaults

    let newCenter = Defaults.cityCenter
    let oldCenter = self.mapView.region.center

    let minDegChangeToUpdate = Constants.Defaults.minDegChangeToUpdate
    let hasLatitudeChanged  = abs(newCenter.latitude - oldCenter.latitude) > minDegChangeToUpdate
    let hasLongitudeChanged = abs(newCenter.longitude - oldCenter.longitude) > minDegChangeToUpdate

    // Prevent min flicker when we set the same center 2nd time
    if hasLatitudeChanged || hasLongitudeChanged {
      let newRegion = MKCoordinateRegionMakeWithDistance(newCenter, Defaults.regionSize, Defaults.regionSize)
      self.mapView.setRegion(newRegion, animated: animated)
    }
  }

  fileprivate func centerUserLocationIfAuthorized(animated: Bool) {
    let authorization = self.location.authorization

    guard authorization == .authorizedAlways || authorization == .authorizedWhenInUse
      else { return }

    _ = self.location.getCurrent()
    .then { userLocation -> () in
      self.mapView.setCenter(userLocation, animated: true)
      self.alertWhenFarFromDefaultCity(userLocation: userLocation)
      return ()
    }
    // if we don't have access then leave as it is
     .catch { _ in () }
  }

  fileprivate func alertWhenFarFromDefaultCity(userLocation: CLLocationCoordinate2D) {
    let cityCenter = CLLocation(coordinate: Constants.Defaults.cityCenter)
    let distance   = cityCenter.distance(from: CLLocation(coordinate: userLocation))

    guard distance > Constants.Defaults.cityRadius
      else { return }

    self.alert.showInvalidCityAlert(in: self) { [weak self] result in
      if result == .showDefault {
        self?.centerDefaultRegion(animated: true)
      }
    }
  }
}

// MARK: - Vehicle locations

extension MapViewController {

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

// MARK: - Notifications

extension MapViewController: LocationAuthorizationObserver, ApplicationActivityObserver {

  func locationAuthorizationDidChange() {
    self.centerUserLocationIfAuthorized(animated: true)
  }

  func applicationDidBecomeActive() {
    self.centerUserLocationIfAuthorized(animated: true)
  }

  func applicationWillResignActive() { }
}

// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {

  // MARK: - Tracking mode

  func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
    let authorization = self.location.authorization
    switch authorization {
    case .denied:        self.alert.showDeniedLocationAuthorizationAlert(in: self)
    case .restricted:    self.alert.showGloballyDeniedLocationAuthorizationAlert(in: self)
    case .notDetermined: self.location.requestAuthorization()
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
