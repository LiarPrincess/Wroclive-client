//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation

protocol ApiManagerType {

  /// Get all currently available lines
  var availableLines: ApiResponse<[Line]> { get }

  /// Get current vehicle locations for selected lines
  func vehicleLocations(for lines: [Line]) -> ApiResponse<[Vehicle]>
}
