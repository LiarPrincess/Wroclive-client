//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
import PromiseKit
import MapKit

class LocationRequestSerialization {

  // MARK: - Request

  static func createRequest(_ lines: [Line]) -> Promise<Data> {
    return Promise { fulfill, reject in
      var data = [String:Any]()
      data["device_id"] = "device_id"
      data["lines"]     = LocationRequestSerialization.serializeLines(lines)

      do {
        let jsonData = try JSONSerialization.data(withJSONObject: data, options: JSONSerialization.WritingOptions(rawValue: 0))
        fulfill(jsonData)
      } catch let error {
        reject(error)
      }
    }
  }

  private static func serializeLines(_ lines: [Line]) -> [[String:String]] {
    return lines.map { line in
      return ["name": line.name,
              "type": line.type == .bus ? "bus" : "tram"
      ]
    }
  }

  // MARK: - Response

  static func parseResponse(_ jsonData: [[String: Any]]) -> Promise<[VehicleLocation]> {
    return Promise { fulfill, reject in
      do {
        let locations = try jsonData.flatMap { return try parseResponseEntry(entry: $0) }
        fulfill(locations)
      } catch {
        reject(NetworkingError.invalidResponse)
      }
    }
  }

  private static func parseResponseEntry(entry: [String: Any]) throws -> [VehicleLocation] {
    guard let lineEntry      = entry["line"]     as? [String: Any],
          let vehicleEntries = entry["vehicles"] as? [[String: Any]]
    else { throw NetworkingError.invalidResponse }

    let line = try Line(lineEntry)

    var result = [VehicleLocation]()
    for vehicleEntry in vehicleEntries {
      guard let vehicleId = vehicleEntry["vehicleId"] as? String,
            let latitude  = vehicleEntry["latitude"]  as? Double,
            let longitude = vehicleEntry["longitude"] as? Double,
            let angle     = vehicleEntry["angle"]     as? Double
      else { throw NetworkingError.invalidResponse }

      let location  = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
      let direction = CLLocationDirection(angle)

      let vehicleLocation = VehicleLocation(vehicleId: vehicleId, line: line, location: location, angle: direction)
      result.append(vehicleLocation)
    }

    return result
  }
}
