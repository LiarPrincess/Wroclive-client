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

  private let mapView = MKMapView()

  //MARK: - Overriden

  override func viewDidLoad() {
    super.viewDidLoad()

    self.initMapView()
  }

  //MARK: - UI Init

  private func initMapView() {
    self.mapView.mapType = .standard
    self.mapView.showsBuildings = true
    self.mapView.showsCompass = true
    self.mapView.showsScale = false
    self.mapView.showsTraffic = false
    self.mapView.showsUserLocation = true
    self.view.addSubview(self.mapView)

    self.mapView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

}
