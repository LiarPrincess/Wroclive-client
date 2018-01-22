//
//  Created by Michal Matuszczyk
//  Copyright © 2018 Michal Matuszczyk. All rights reserved.
//

import MapKit
import RxSwift
import RxCocoa

extension Reactive where Base: MKMapView {

  /// Reactive wrapper for `mapType` property.
  public var mapType: Binder<MKMapType> {
    return Binder(self.base) { mapView, value in
      mapView.mapType = value
    }
  }
}
