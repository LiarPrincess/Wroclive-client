// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import RxSwift

public protocol ApiType {

  /// Get all currently available mpk lines
  func getLines() -> Single<[Line]>

  /// Get current vehicle locations for selected lines
  func getVehicleLocations(for lines: [Line]) -> Single<[Vehicle]>
}
