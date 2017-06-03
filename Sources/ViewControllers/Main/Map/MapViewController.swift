//
//  Created by Michal Matuszczyk
//  Copyright © Michal Matuszczyk. All rights reserved.
//

import UIKit
import MapKit
import SnapKit

//MARK: - MapViewController

class MapViewController: UIViewController {

  //MARK: - Properties

  let mapView = MKMapView()

  fileprivate lazy var locationManager: CLLocationManager = {
    let locationManager = CLLocationManager()
    locationManager.distanceFilter = 5.0
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    return locationManager
  }()

  //MARK: - Overriden

  override func viewDidLoad() {
    super.viewDidLoad()

    // not in did load!
    self.requestInUseAuthorizationIfNeeded()
    let center = self.locationManager.location?.coordinate ?? CLLocationCoordinate2D(latitude: 51.109524, longitude: 17.032564)
    mapView.region = MKCoordinateRegionMakeWithDistance(center, 2500.0, 2500.0)

    self.initLayout()
  }

  //MARK: - UI Init

  private func initLayout() {
    self.mapView.mapType           = .standard
    self.mapView.showsBuildings    = true
    self.mapView.showsCompass      = true
    self.mapView.showsScale        = false
    self.mapView.showsTraffic      = false
    self.mapView.showsUserLocation = true
    self.view.addSubview(self.mapView)

    self.mapView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

  func requestInUseAuthorizationIfNeeded() {
    let authorizationStatus = CLLocationManager.authorizationStatus()

//    guard !authorizationStatus.forbidsLocalization else {
//      return
//    }
//
//    guard authorizationStatus == .notDetermined else {
//      return
//    }

    self.locationManager.requestWhenInUseAuthorization()
  }

}
