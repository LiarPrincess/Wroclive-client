// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

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
