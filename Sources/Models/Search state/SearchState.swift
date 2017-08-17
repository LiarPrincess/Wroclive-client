//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation

private struct PropertyKeys {
  static let selectedLineType = "selectedLineType"
  static let selectedLines    = "selectedLines"
}

class SearchState: NSObject, NSCoding {

  // MARK: - Properties

  let selectedLineType: LineType
  let selectedLines:    [Line]

  // MARK: - Init

  init(withSelected lineType: LineType, lines: [Line]) {
    self.selectedLineType = lineType
    self.selectedLines    = lines
  }

  // MARK: - NSCoding

  required convenience init?(coder aDecoder: NSCoder) {
    guard let selectedLineType = LineType(rawValue: aDecoder.decodeInteger(forKey: PropertyKeys.selectedLineType)),
          let selectedLines    = aDecoder.decodeObject(forKey: PropertyKeys.selectedLines) as? [Line]
      else { return nil }

    self.init(withSelected: selectedLineType, lines: selectedLines)
  }

  func encode(with aCoder: NSCoder) {
    aCoder.encode(self.selectedLineType.rawValue, forKey: PropertyKeys.selectedLineType)
    aCoder.encode(self.selectedLines,             forKey: PropertyKeys.selectedLines)
  }

  // MARK: - Equals

  override func isEqual(_ object: Any?) -> Bool {
    guard let other = object as? SearchState else { return false }
    return self.selectedLineType == other.selectedLineType
        && self.selectedLines    == other.selectedLines
  }
}
