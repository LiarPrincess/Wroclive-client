// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

protocol ApiManagerType {

  /// Get all currently available lines
  var availableLines: ApiResponse<[Line]> { get }

  /// Get current vehicle locations for selected lines
  func vehicleLocations(for lines: [Line]) -> ApiResponse<[Vehicle]>
}
