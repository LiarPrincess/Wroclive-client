// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import RxSwift

protocol ApiManagerType: ManagerType {

  /// Get all currently available lines
  var availableLines: Single<[Line]> { get }

  /// Get current vehicle locations for selected lines
  func vehicleLocations(for lines: [Line]) -> Single<[Vehicle]>
}
