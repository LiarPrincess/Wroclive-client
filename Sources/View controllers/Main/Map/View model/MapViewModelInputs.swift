//
//  Created by Michal Matuszczyk
//  Copyright © 2018 Michal Matuszczyk. All rights reserved.
//

import UIKit
import MapKit
import RxSwift
import RxCocoa

protocol MapViewModelInputs {
  var trackingModeChanged: AnyObserver<MKUserTrackingMode> { get }

  var viewDidAppear: AnyObserver<Void> { get }
}
