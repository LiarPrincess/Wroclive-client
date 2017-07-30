//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation

fileprivate struct PropertyKeys {
  static let name    = "name"
  static let type    = "type"
  static let subtype = "subtype"
}

class Line: NSObject, NSCoding {

  // MARK: - Properties

  let name:    String
  let type:    LineType
  let subtype: LineSubtype

  // MARK: - Init

  init(name: String, type: LineType, subtype: LineSubtype) {
    self.name    = name
    self.type    = type
    self.subtype = subtype
  }

  // MARK: - NSCoding

  required convenience init?(coder aDecoder: NSCoder) {
    guard let name    = aDecoder.decodeObject(forKey: PropertyKeys.name) as? String,
          let type    = LineType   (rawValue: aDecoder.decodeInteger(forKey: PropertyKeys.type)),
          let subtype = LineSubtype(rawValue: aDecoder.decodeInteger(forKey: PropertyKeys.subtype))
    else { return nil }

    self.init(name: name, type: type, subtype: subtype)
  }

  func encode(with aCoder: NSCoder) {
    aCoder.encode(self.name,             forKey: PropertyKeys.name)
    aCoder.encode(self.type.rawValue,    forKey: PropertyKeys.type)
    aCoder.encode(self.subtype.rawValue, forKey: PropertyKeys.subtype)
  }

  // MARK: - Equals

  override func isEqual(_ object: Any?) -> Bool {
    guard let other = object as? Line else { return false }
    return self.name   == other.name
        && self.type   == other.type
       && self.subtype == other.subtype
  }
}

// MARK: - JSON

enum LineParsingError: Error {
  case invalidInput
}

extension Line {

  convenience init(_ jsonData: [String: Any]) throws {
    guard let name    = jsonData["name"]    as? String,
          let type    = jsonData["type"]    as? String,
          let subtype = jsonData["subtype"] as? String,

          let lineType    = Line.parseLineType(type),
          let lineSubtype = Line.parseLineSubtype(subtype)
      else { throw LineParsingError.invalidInput }

    self.init(name: name, type: lineType, subtype: lineSubtype)
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
