//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
import PromiseKit

class ApiManagerImpl: ApiManager {

  func getAvailableLines() -> Promise<[Line]> {
    let endpoint = AvailableLinesEndpoint()
    return endpoint.sendRequest()
  }

  func getVehicleLocations(for lines: [Line]) -> Promise<[Vehicle]> {
    let endpoint = VehicleLocationsEndpoint()
    return endpoint.sendRequest(data: lines)
  }
}
