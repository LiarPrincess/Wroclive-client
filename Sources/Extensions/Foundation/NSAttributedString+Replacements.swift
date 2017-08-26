//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import Foundation

struct TextReplacement {
  let text:        String
  let attachement: NSTextAttachment

  init(_ text: String, _ replacement: NSTextAttachment) {
    self.text        = text
    self.attachement = replacement
  }
}

extension NSAttributedString {

  func withReplacements(_ replacements: [TextReplacement]) -> NSAttributedString {
    let replacementPositions       = self.findReplacementPositions(replacements)
    let replacementPositionsSorted = replacementPositions.sorted { $0.position.location < $1.position.location }

    let result = NSMutableAttributedString()

    var previousRangeEnd = 0
    for (range, replacement) in replacementPositionsSorted {
      let beforeRange = NSRange(start: previousRangeEnd, finish: range.start)
      result.append(self.attributedSubstring(from: beforeRange))
      result.append(NSAttributedString(attachment: replacement.attachement))

      previousRangeEnd = range.end
    }

    let nsString = NSString(string: self.string)
    let afterRange = NSRange(start: previousRangeEnd, finish: nsString.length)
    result.append(self.attributedSubstring(from: afterRange))

    return result
  }

  private typealias ReplacementPosition = (position: NSRange, replacement: TextReplacement)

  private func findReplacementPositions(_ replacements: [TextReplacement]) -> [ReplacementPosition] {
    let nsString = NSString(string: self.string)
    let replacedTexts = replacements.map { $0.text }

    return self.string
      .findPositions(of: replacedTexts)
      .map     { ($0, nsString.substring(with: $0)) }
      .flatMap { (position, substring) in
        return replacements
          .first { $0.text.caseInsensitiveCompare(substring) == .orderedSame }
          .map   { (position, $0) }
    }
  }
}
