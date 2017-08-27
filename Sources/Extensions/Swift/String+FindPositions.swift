//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation

extension String {

  func findPosition(of substring: String) -> [NSRange] {
    return self.findPositions(of: [substring])
  }

  func findPositions(of substrings: [String]) -> [NSRange] {
    let nsSelf = NSString(string: self)

    // swiftlint:disable force_try
    let regexExpr = substrings.joined(separator: "|")
    let regex     = try! NSRegularExpression(pattern: regexExpr, options: [.caseInsensitive])

    return regex
      .matches(in: self, options: [], range: NSRange(location: 0, length: nsSelf.length))
      .map { $0.range }
  }
}
