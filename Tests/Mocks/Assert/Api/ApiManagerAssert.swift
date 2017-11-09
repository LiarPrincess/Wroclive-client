//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
import PromiseKit

class ApiManagerAssert: ApiManager {

  func getAvailableLines() -> Promise<[Line]> {
    assertNotCalled()
  }

  func getVehicleLocations(for lines: [Line]) -> Promise<[Vehicle]> {
    assertNotCalled()
  }
}
