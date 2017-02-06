//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import UIKit
import MapKit

class MapController: UIViewController, MapControllerProtocol {

  //MARK: - Properties

  @IBOutlet weak var mapView: MKMapView!

  //MARK: - Overriden

  override func viewDidLoad() {
    super.viewDidLoad()

    let center = MapKitHelper.currentLocation?.coordinate ?? CLLocationCoordinate2D(latitude: 51.109524, longitude: 17.032564)
    mapView.region = MKCoordinateRegionMakeWithDistance(center, 2500.0, 2500.0)
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    MapKitHelper.requestInUseAuthorizationIfNeeded()
  }

  //MARK: - Methods

  func centerOnUserLocation() {
    if !MapKitHelper.authorizationStatus.allowsLocalization {
      MapKitHelper.presentAlertToChangeAuthorization(parent: self)
    }

    guard MapKitHelper.authorizationStatus.allowsLocalization else {
      return
    }

    if let userPosition = MapKitHelper.currentLocation?.coordinate {
      mapView.setCenter(userPosition, animated: true)
    }
  }

}
