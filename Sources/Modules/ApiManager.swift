//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
import RxSwift
import Result

class ApiManager: ApiManagerType {

  var availableLines: ApiResponse<[Line]> {
    let endpoint = AvailableLinesEndpoint()
    return endpoint.sendRequest()
  }

  func vehicleLocations(for lines: [Line]) -> ApiResponse<[Vehicle]> {
    let endpoint = VehicleLocationsEndpoint()
    return endpoint.sendRequest(data: lines)
  }
}
