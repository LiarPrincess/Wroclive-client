//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
import PromiseKit
@testable import Wroclive

// swiftlint:disable implicitly_unwrapped_optional

class ApiManagerMock: ApiManagerType {

  var availableLines: Promise<[Line]>!

  private(set) var availableLinesCallCount = 0

  func getAvailableLines() -> Promise<[Line]> {
    self.availableLinesCallCount += 1
    return self.availableLines
  }

  func getVehicleLocations(for lines: [Line]) -> Promise<[Vehicle]> {
    return Promise(value: [])
  }
}
