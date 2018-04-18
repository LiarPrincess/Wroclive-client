//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import RxSwift

protocol LiveManagerType {

  /// Tracking results
  var vehicleLocations: ApiResponse<[Vehicle]> { get }

  /// Start tracking new set of lines
  func startTracking(_ lines: [Line])

  /// Resume tracking
  func resumeTracking()

  /// Pause tracking, so that new values will not be send
  func pauseTracking()
}
