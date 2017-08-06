//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation

class LineLocationsParser {

  private init() {}

  static func parse(_ json: [String: Any]) throws -> [VehicleLocation] {
    guard let lineJson     = json["line"]     as? [String: Any],
          let vehiclesJson = json["vehicles"] as? [[String: Any]]
      else { throw NetworkError.invalidResponse }

    let line = try LinesParser.parse(lineJson)
    return try vehiclesJson.map { return try LineLocationsParser.parseVehicleLocation(line, json: $0) }
  }

  private static func parseVehicleLocation(_ line: Line, json: [String: Any]) throws -> VehicleLocation {
    guard let vehicleId = json["vehicleId"] as? String,
          let latitude  = json["latitude"]  as? Double,
          let longitude = json["longitude"] as? Double,
          let angle     = json["angle"]     as? Double
      else { throw NetworkError.invalidResponse }

    return VehicleLocation(vehicleId: vehicleId, line: line, latitude: latitude, longitude: longitude, angle: angle)
  }

}
