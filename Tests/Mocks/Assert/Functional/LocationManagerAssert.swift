//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import MapKit
import PromiseKit

class LocationManagerAssert: LocationManager {

  func getCurrent() -> Promise<CLLocationCoordinate2D> {
    assertNotCalled()
  }

  var authorization: CLAuthorizationStatus {
    assertNotCalled()
  }

  func requestAuthorization() {
    assertNotCalled()
  }
}
