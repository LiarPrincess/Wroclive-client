//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
import PromiseKit

class ApiManagerMock: ApiManager {

  // MARK: - Properties

  private let lines:    [Line]
  private let vehicles: [Vehicle]

  // MARK: - Init

  init(lines: [Line] = [], vehicles: [Vehicle] = []) {
    self.lines    = lines
    self.vehicles = vehicles
  }

  // MARK: - NetworkManager

  func getAvailableLines() -> Promise<[Line]> {
    return Promise(value: self.lines)
  }

  func getVehicleLocations(for lines: [Line]) -> Promise<[Vehicle]> {
    return Promise(value: self.vehicles)
  }
}
