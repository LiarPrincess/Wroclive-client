//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
import PromiseKit

class ApiManagerImpl: ApiManager {

  func getAvailableLines() -> Promise<[Line]> {
    let endpoint = AvailableLinesEndpoint()
    return Managers.network.send(endpoint: endpoint, data: ())
  }

  func getVehicleLocations(for lines: [Line]) -> Promise<[Vehicle]> {
    let endpoint = VehicleLocationsEndpoint()
    return Managers.network.send(endpoint: endpoint, data: lines)
  }
}
