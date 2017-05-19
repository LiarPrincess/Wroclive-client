//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import UIKit
import MapKit

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
    mapView.mapType = .standard
    mapView.showsBuildings = true
    mapView.showsCompass = true
    mapView.showsScale = false
    mapView.showsTraffic = false
    mapView.showsUserLocation = true
    view.addSubview(mapView)

    mapView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

}
