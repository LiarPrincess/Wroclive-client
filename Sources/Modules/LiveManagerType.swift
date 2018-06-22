// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

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
