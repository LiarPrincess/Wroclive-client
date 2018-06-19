//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import RxSwift

protocol LiveManagerType {

  /// Tracking results
  var mpkVehicles: ApiResponse<[Vehicle]> { get }

  /// Start tracking new set of lines
  func startTracking(_ lines: [Line])

  /// Resume updates
  func resumeUpdates()

  /// Pause updates, so that new values will not be send
  func pauseUpdates()
}
