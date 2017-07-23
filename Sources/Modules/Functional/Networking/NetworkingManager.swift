//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
import PromiseKit

protocol NetworkingManager {

  /// Get all currently available lines
  func getLineDefinitions() -> Promise<[Line]>

  /// Get current vehicle locations for selected lines
  func getVehicleLocations(_ lines: [Line]) -> Promise<[VehicleLocation]>

}
