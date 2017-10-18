//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation

private struct PropertyKeys {
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
