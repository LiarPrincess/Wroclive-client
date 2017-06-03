//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import MapKit
import SnapKit

//MARK: - MapViewController

class MapViewController: UIViewController {

  //MARK: - Properties

  let mapView = MKMapView()

  //MARK: - Overriden

  override func viewDidLoad() {
    super.viewDidLoad()
    self.initLayout()
  }

  override func viewWillAppear(_ animated: Bool) {
    LocationManager.instance.requestInUseAuthorization()

    let region = LocationManager.instance.getInitialRegion()
    self.mapView.setRegion(region, animated: false)
  }

}

extension MapViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
    let authorizationStatus = LocationManager.instance.authorizationStatus
    let isAuthorizationDenied = authorizationStatus == .restricted || authorizationStatus == .denied

    if isAuthorizationDenied {
      LocationManager.instance.showChangeAuthorizationAlert(in: self)
    }
  }
}
