//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
import PromiseKit
@testable import Wroclive

class ApiManagerMock: ApiManagerType {

  func getAvailableLines() -> Promise<[Line]> {
    return Promise(value: [])
  }

  func getVehicleLocations(for lines: [Line]) -> Promise<[Vehicle]> {
    return Promise(value: [])
  }
}
