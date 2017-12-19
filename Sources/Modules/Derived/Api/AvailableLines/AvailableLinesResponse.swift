//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation

struct AvailableLinesResponseModel: Decodable {
  let timestamp: String
  let data:      [LineModel]

  struct LineModel: Decodable {
    let name:    String
    let type:    String
    let subtype: String
  }
}

class AvailableLinesResponseParser: JSONResponseParser {

  typealias JSONModel    = AvailableLinesResponseModel
  typealias ResponseData = [Line]

  static func map(_ model: JSONModel) throws -> ResponseData {
    return try model.data.map(parseLine)
  }

  // MARK: - Parse line

  private typealias LineModel = AvailableLinesResponseModel.LineModel

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
