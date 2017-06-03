//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
import MapKit
import ReSwift

//MARK: - AppState

struct AppState: StateType {
  var trackingMode: MKUserTrackingMode = .none

  var lineSelectionState = LineSelectionState()
  var bookmarksState = BookmarksState()
}
