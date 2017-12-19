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
    parameters["lines"] = data.map(encodeLine)
    return parameters
  }

  private static func encodeLine(_ line: Line) -> [String:Any] {
    return [
      "name": line.name,
      "type": self.encodeType(line.type)
    ]
  }

  private static func encodeType(_ type: LineType) -> String {
    switch type {
    case .bus:  return "bus"
    case .tram: return "tram"
    }
  }
}
