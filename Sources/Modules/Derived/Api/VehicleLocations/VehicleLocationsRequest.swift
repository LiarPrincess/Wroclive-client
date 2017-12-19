//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
import Alamofire

class VehicleLocationsParameterEncoder: ParameterEncoder {

  typealias ParameterData = [Line]

  static func encode(_ data: ParameterData) -> Parameters? {
    var parameters      = Parameters()
    parameters["lines"] = encodeLines(data)
    return parameters
  }

  static func encodeLines(_ lines: [Line]) -> [[String:Any]] {
    return lines.map {[
      "name": $0.name,
      "type": $0.type == .bus ? "bus" : "tram"
    ]}
  }
}
