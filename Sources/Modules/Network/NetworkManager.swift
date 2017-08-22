//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
import PromiseKit

protocol NetworkManager {

  /// Get all currently available lines
  func getAvailableLines() -> Promise<[Line]>

  /// Get current vehicle locations for selected lines
  func getVehicleLocations(for lines: [Line]) -> Promise<[Vehicle]>
}
