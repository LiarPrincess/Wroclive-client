//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit
import MapKit

fileprivate typealias Constants = MapViewControllerConstants

extension MapViewController {

  func initLayout() {
    self.mapView.mapType           = Constants.MapView.mapType
    self.mapView.showsBuildings    = Constants.MapView.showsBuildings
    self.mapView.showsCompass      = Constants.MapView.showsCompass
    self.mapView.showsScale        = Constants.MapView.showsScale
    self.mapView.showsTraffic      = Constants.MapView.showsTraffic
    self.mapView.showsUserLocation = Constants.MapView.showsUserLocation
    self.mapView.delegate          = self
    self.view.addSubview(self.mapView)

    self.mapView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

}
