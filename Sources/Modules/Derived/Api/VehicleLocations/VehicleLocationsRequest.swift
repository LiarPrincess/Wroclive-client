//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

class VehicleLocationsRequest {
  static func encode(_ lines: [Line]) -> [[String:Any]] {
    return lines.map {[
      "name": $0.name,
      "type": $0.type == .bus ? "bus" : "tram"
    ]}
  }
}
