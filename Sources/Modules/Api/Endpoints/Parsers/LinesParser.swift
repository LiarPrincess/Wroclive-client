//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

class LinesParser {

  private init() {}

  static func parse(_ json: JSONDictionary) throws -> Line {
    guard let name          = json["name"]    as? String,
          let typeString    = json["type"]    as? String,
          let subtypeString = json["subtype"] as? String,

          let type    = LinesParser.parseLineType(typeString),
          let subtype = LinesParser.parseLineSubtype(subtypeString)
      else { throw NetworkError.invalidResponse }

    return Line(name: name, type: type, subtype: subtype)
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
