//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation

struct VehicleLocationsResponseModel: Decodable {
  let timestamp: String
  let data:      [LineLocationModel]

  struct LineLocationModel: Decodable {
    let line:     LineModel
    let vehicles: [VehicleModel]
  }

  struct LineModel: Decodable {
    let name:    String
    let type:    String
    let subtype: String
  }

  struct VehicleModel: Decodable {
    let id:    String
    let lat:   Double
    let lng:   Double
    let angle: Double
  }
}

class VehicleLocationsResponseParser: JSONResponseParser {
  typealias JSONModel    = VehicleLocationsResponseModel
  typealias ResponseData = [Vehicle]

  static func map(_ model: JSONModel) throws -> ResponseData {
    return try model.data.flatMap(parseVehicleLocations)
  }

  private typealias LineLocationModel = VehicleLocationsResponseModel.LineLocationModel

  private static func parseVehicleLocations(_ model: LineLocationModel) throws -> [Vehicle] {
    let line = try parseLine(model.line)
    return model.vehicles.map {
      Vehicle(id: $0.id, line: line, latitude: $0.lat, longitude: $0.lng, angle: $0.angle)
    }
  }

  // MARK: - Parse line

  private typealias LineModel = VehicleLocationsResponseModel.LineModel

  private static func parseLine(_ model: LineModel) throws -> Line {
    guard let type    = parseLineType(model.type),
          let subtype = parseLineSubtype(model.subtype)
      else { throw ApiError.invalidResponse }
    return Line(name: model.name, type: type, subtype: subtype)
  }

  private static func parseLineType(_ type: String) -> LineType? {
    switch type.uppercased() {
    case "TRAM": return .tram
    case "BUS" : return .bus
    default:     return nil
    }
  }

  private static func parseLineSubtype(_ subtype: String) -> LineSubtype? {
    switch subtype.uppercased() {
    case "REGULAR":   return .regular
    case "EXPRESS":   return .express
    case "HOUR":      return .peakHour
    case "SUBURBAN":  return .suburban
    case "ZONE":      return .zone
    case "LIMITED":   return .limited
    case "TEMPORARY": return .temporary
    case "NIGHT":     return .night
    default:          return nil
    }
  }
}
