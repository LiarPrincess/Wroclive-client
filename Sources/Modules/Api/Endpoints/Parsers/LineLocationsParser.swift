//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation

class LineLocationsParser {

  private init() {}

  static func parse(_ json: JSONDictionary) throws -> [Vehicle] {
    guard let lineJson     = json["line"]     as? JSONDictionary,
          let vehiclesJson = json["vehicles"] as? JSONArray
      else { throw NetworkError.invalidResponse }

    let line = try LinesParser.parse(lineJson)
    return try vehiclesJson.map { return try LineLocationsParser.parseVehicleLocation(line, json: $0) }
  }

  private static func parseVehicleLocation(_ line: Line, json: JSONDictionary) throws -> Vehicle {
    guard let id        = json["id"]    as? String,
          let latitude  = json["lat"]   as? Double,
          let longitude = json["lng"]   as? Double,
          let angle     = json["angle"] as? Double
      else { throw NetworkError.invalidResponse }

    return Vehicle(id: id, line: line, latitude: latitude, longitude: longitude, angle: angle)
  }
}
