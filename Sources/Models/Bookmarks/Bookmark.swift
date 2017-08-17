//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation

private struct PropertyKeys {
  static let name  = "name"
  static let lines = "lines"
}

class Bookmark: NSObject, NSCoding {

  // MARK: - Properties

  let name:  String
  let lines: [Line]

  // MARK: - Init

  init(name: String, lines: [Line]) {
    self.name  = name
    self.lines = lines
  }

  // MARK: - NSCoding

  required convenience init?(coder aDecoder: NSCoder) {
    guard let name  = aDecoder.decodeObject(forKey: PropertyKeys.name)  as? String,
          let lines = aDecoder.decodeObject(forKey: PropertyKeys.lines) as? [Line]
    else { return nil }

    self.init(name: name, lines: lines)
  }

  func encode(with aCoder: NSCoder) {
    aCoder.encode(self.name,  forKey: PropertyKeys.name)
    aCoder.encode(self.lines, forKey: PropertyKeys.lines)
  }

  // MARK: - Equals

  override func isEqual(_ object: Any?) -> Bool {
    guard let other = object as? Bookmark else { return false }
    return self.name  == other.name
        && self.lines == other.lines
  }
}
