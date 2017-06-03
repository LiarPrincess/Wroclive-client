//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import MapKit
import SnapKit

class MapViewController: UIViewController {

  //MARK: - Properties

  let mapView = MKMapView()

  //MARK: - Overriden

  override func viewDidLoad() {
    super.viewDidLoad()
    self.initLayout()
  }

  override func viewDidAppear(_ animated: Bool) {
    self.startShowingUserLocation()
  }

  override var bottomLayoutGuide: UILayoutSupport {
    return LayoutGuide(length: 44.0)
  }

  //MARK: - Methods

  private func startShowingUserLocation() {
    LocationManager.instance.requestInUseAuthorization()

    let region = LocationManager.instance.getInitialRegion()
    self.mapView.setRegion(region, animated: false)
  }

}

//MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {

  //MARK: - Tracking mode

  func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
    let authorizationStatus = LocationManager.instance.authorizationStatus
    let isAuthorizationDenied = authorizationStatus == .restricted || authorizationStatus == .denied

    if isAuthorizationDenied {
      LocationManager.instance.showChangeAuthorizationAlert(in: self)
    }
  }

}
