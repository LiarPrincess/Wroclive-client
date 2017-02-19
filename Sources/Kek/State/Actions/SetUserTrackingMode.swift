//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import Foundation
import MapKit
import ReSwift

struct SetUserTrackingMode: ApplicableAction {
  let trackingMode: MKUserTrackingMode

  init(_ trackingMode: MKUserTrackingMode) {
    self.trackingMode = trackingMode
  }

  func apply(state: AppState) -> AppState {
    var result = state
    result.trackingMode = self.trackingMode
    return result
  }
}
