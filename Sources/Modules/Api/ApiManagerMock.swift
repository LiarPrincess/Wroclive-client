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
  private let delay:    TimeInterval

  // MARK: - Init

  init(lines: [Line] = [], vehicles: [Vehicle] = [], delay: TimeInterval = 0.0) {
    self.lines    = lines
    self.vehicles = vehicles
    self.delay    = delay
  }

  // MARK: - NetworkManager

  func getAvailableLines() -> Promise<[Line]> {
    return after(seconds: self.delay)
      .then { return Promise(value: self.lines) }
  }

  func getVehicleLocations(for lines: [Line]) -> Promise<[Vehicle]> {
    return after(seconds: self.delay)
      .then { return Promise(value: self.vehicles) }
  }
}
