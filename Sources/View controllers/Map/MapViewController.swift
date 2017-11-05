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

  let mapView = MKMapView()

  // MARK: - Init

  convenience init() {
    self.init(nibName: nil, bundle: nil)
  }

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
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
    let authorization = Managers.location.authorization
    switch authorization {
    case .denied:        Managers.alert.showDeniedLocationAuthorizationAlert(in: self)
    case .restricted:    Managers.alert.showGloballyDeniedLocationAuthorizationAlert(in: self)
    case .notDetermined: Managers.location.requestAuthorization()
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
