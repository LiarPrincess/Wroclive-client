//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
import PromiseKit

class LineParser {

  static func parse(_ jsonData: [[String: Any]]) -> Promise<[Line]> {
    return Promise { fulfill, reject in
      do {
        let lines = try jsonData.map { return try parseLine($0) }
        fulfill(lines)
      } catch let error {
        reject(error)
      }
    }
  }

  private static func parseLine(_ jsonData: [String: Any]) throws -> Line {
    guard let name    = jsonData["name"]    as? String,
          let type    = jsonData["type"]    as? String,
          let subtype = jsonData["subtype"] as? String,

          let lineType    = parseLineType(type),
          let lineSubtype = parseLineSubtype(subtype)
    else { throw NetworkingError.invalidResponse }

    return Line(name: name, type: lineType, subtype: lineSubtype)
  }

  private static func parseLineType(_ type: String) -> LineType? {
    switch type.lowercased() {
    case "tram": return .tram
    case "bus" : return .bus
    default:     return nil
    }
  }

  private static func parseLineSubtype(_ subtype: String) -> LineSubtype? {
    switch subtype.lowercased() {
    case "regular":   return .regular
    case "express":   return .express
    case "hour":      return .hour
    case "suburban":  return .suburban
    case "zone":      return .zone
    case "limited":   return .limited
    case "temporary": return .temporary
    case "night":     return .night
    default:          return nil
    }
  }

}
