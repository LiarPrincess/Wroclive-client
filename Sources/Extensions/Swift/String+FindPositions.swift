//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation

extension String {

  func findPosition(of text: String) -> [NSRange] {
    return self.findPositions(of: [text])
  }

  func findPositions(of texts: [String]) -> [NSRange] {
    let nsSelf = NSString(string: self)

    // swiftlint:disable force_try
    let regexExpr = texts.joined(separator: "|")
    let regex     = try! NSRegularExpression(pattern: regexExpr, options: [.caseInsensitive])

    let items = regex.matches(in: self, options: [], range: NSRange(location: 0, length: nsSelf.length))
    return items.map { $0.range }
  }
}
